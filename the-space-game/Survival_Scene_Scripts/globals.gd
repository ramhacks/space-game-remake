extends Node

#Enum for power groups array
const PowerG = preload("res://enums/power_enums.gd").PowerGroups

## Holds tracking data for connected node groups.
##
## **Dictionary Format:**
## `group_name: [current_power, max_power, line_connecting_group, points]`
##
## **Points Breakdown:**
## The [code]points[/code] array stores coordinates in pairs, representing separate,
## disconnected line segments rather than a single continuous path.
## * Each consecutive pair (e.g., indices 0-1, 2-3) forms an independent segment.
## * The line jumps between pairs rather than connecting them sequentially, preventing
##   unwanted bridging lines across the canvas.
var power_groups = {}

var starting_resources = 300

var last_deleted_tower: Node;


var total_current = 0
var total_capacity = 0
#so we don't have to loop over the dictionaries to get the totals to display to the player

#This will only ever hold global variables, maybe functions but it is
#not recommended unless absolutly necessary
func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr

func GetAllTreeNodes(node , listOfAllNodesInTree, type_string): #recursive
	if(node.get_class() == type_string):
		listOfAllNodesInTree.append(node)
	for childNode in node.get_children():
		GetAllTreeNodes(childNode, listOfAllNodesInTree, type_string)
	return listOfAllNodesInTree

var main_scene

## amount of resources the current player has
var resources = starting_resources
var RPM = 0
var sprite_collider_instance
var tower_selection_mode = false
var tower_selected

var wave_number: int = 0

var selection_node

var tower_hovering = false

var tower_node_amount = 0
var NO_SOLAR_TOWER = true

var global_power_timer_on = Timer.new()
var power_on_delay = 0.5
var global_power_timer_off = Timer.new()
var power_off_delay = 0.5


var power_lines

var power_line_segment

# [Mineral Change, Action]
var mineral_queue = []

# [tower to remove]
var removal_queue = []
var paused = false # when set to true stop power timer

## sent when a tower requests power but there is not enough power available to give it any
signal no_power_available(sender)


func reset_all():
	paused = false
	mineral_queue = []
	tower_hovering = false
	tower_selection_mode = false
	resources = starting_resources
	RPM = 0
	total_current = 0
	total_capacity = 0
	power_groups = {}
	NO_SOLAR_TOWER = true
	wave_number = 0



# func _connect_signal()
# manage power timers so solar stations are all synced
func _ready():
	global_power_timer_on.one_shot = true
	global_power_timer_off.one_shot = true
	global_power_timer_off.wait_time = power_off_delay
	global_power_timer_off.timeout.connect(start_on)
	global_power_timer_on.wait_time = power_on_delay
	global_power_timer_on.timeout.connect(start_off)

	add_child(global_power_timer_on)
	add_child(global_power_timer_off)
	global_power_timer_on.start()

	#Power Line Area Nodes, can be used for a variety of purposes but best to detect if part of a node is not connected to a graph
	#Will do this by checking
	power_lines = preload("res://General_Purpose_Scenes/Power_Group_Line.tscn")
	power_line_segment = preload("res://General_Purpose_Scenes/power_line_segment.tscn")
	sprite_collider_instance = preload("res://towers/sprite_collision_shape_setter.tscn")

func add_to_mineral_queue(mineral_change: int, target_function: Callable):
	mineral_queue.append([mineral_change, target_function])


func pause_game():
	paused = true


func restart_game():
	paused = false
	global_power_timer_on.start()


func start_off():
	if !paused:
		global_power_timer_off.start()

func start_on():
	if !paused:
		global_power_timer_on.start()



#IMPORTANT, connects them based on group only, if not in group wont connect line between a group at all
func connect_group_lines(self_node):

	var news = power_groups[self_node.group_][PowerG.MAX_POWER] - self_node.power_capacity
	power_groups[self_node.group_][PowerG.MAX_POWER] = news



	total_capacity -= self_node.power_capacity

	if(total_capacity > 0 and total_capacity >= total_current):
		total_current = total_current % total_capacity
	elif(total_capacity > 0 and total_capacity < total_current):
		total_current = total_current
	else:
		total_capacity = 0
		total_current = 0

	get_tree().call_group('tower_node', "reset_line")

	var group_to_erase = []
	for power in power_groups:
		if(get_tree().get_node_count_in_group(power) == 0):
			group_to_erase.append(power)

	for g_ in group_to_erase:
		power_groups.erase(g_)

func _process(delta: float) -> void:
	if len(mineral_queue):
		var output = mineral_queue.pop_front()

		if resources-output[0] >= 0:
			resources = resources - output[0]
			output[1].call()


#Group Power Manegment
func group_changed_adjust_max_power(group_target):
	power_groups[group_target][1] = 0
	for node in get_tree().get_nodes_in_group(group_target):
		power_groups[group_target][1] += node.power_capacity

func power_requested(tower, group, power_needed):
	if(group in power_groups) and !paused:
		if(power_groups[group][0]-power_needed > 0):
			tower.do_process()
			power_groups[group][0] -= power_needed
			total_current -= power_needed
		else:
			no_power_available.emit(tower)


func all_in(connection_input, target_connections):
	var check = []
	for node in target_connections:
		if node in connection_input:
			check.append(node)

	if len(check) == len(target_connections):
		return true
	else:
		return false

#Only called by remove_node_group when done, unless removal_queue is empty then directly called when remove-tower_node is called
func advance_removal_queue() -> void:

	if len(removal_queue):

		remove_node_group(removal_queue.pop_front())

#Combine two arrays and removing duplicates
func combine_set(arr1, arr2) -> Array:
	var unique_dict = {}

	for item in arr1 + arr2:
		unique_dict[item] = true

	var combined = unique_dict.keys()
	return combined

# How towers are removed now:
# Queue system, only remove one tower at a time do not remove asynchronously
# Step 1:
	# remove connection references from directly connected towers, return these nodes (named k_nodes)
# Step 2:
	# get all nodes connected to the k_nodes.
	# DFS to get groups of nodes that are connected to the k_nodes and return all these nodes. Inside dfs reassign
	# groups
	# after dfs if k_node found in group skip, we don't need to reassign groups again

func remove_node_group(tower):
	last_deleted_tower = tower
	tower.remove_from_group("Placed_Towers")
	var k_nodes_array = tower.connections # Direct node connections
	power_groups[tower.group_][0] = power_groups[tower.group_][0] - tower.power_capacity
	total_capacity -= tower.power_capacity

	#This holds k nodes that was found to be in a k_node_group
	var k_skip = []

	for conn in k_nodes_array:
		conn.connections.erase(tower)
		if conn in k_skip:
			continue # We don't need to make another group this node is already in a group defined
		var new_group_name = str(power_groups.size()+1)
		power_groups[new_group_name] = [0, 0]

		# First change group of self then move on to changing connections
		conn.remove_from_group(conn.group_)
		conn.group_ = new_group_name
		conn.add_to_group(new_group_name)
		power_groups[new_group_name][1] += conn.power_capacity
		total_capacity += conn.power_capacity
		var group = iterativeDFS_main(conn, new_group_name)

		var inters = group.filter(func(item): return k_nodes_array.has(item))

		k_skip = combine_set(k_skip, inters)

	tower.queue_free()






# Target function to fix that is causing issues
func remove_node_from_group(tower):
	if len(removal_queue) == 0:
		removal_queue.append(tower)
		advance_removal_queue()
	else:
		removal_queue.append(tower)

	return


func find_closest_solar(v):
	var discovered = []
	var stack = []
	stack.push_front(v)

	# IF self is solar this function is irrelevent
	if v.custom_class == "Solar" and !v.built:
		return true


	var found = false

	while len(stack) > 0:
		var s = stack[0]
		stack.pop_front()
		# FIX: The connections loop MUST be nested inside this validation block
		if typeof(s) != TYPE_INT and is_instance_valid(s) and s not in discovered:

			discovered.append(s)


			for node in s.connections:
				if typeof(node) != TYPE_INT and is_instance_valid(node) and node not in discovered and not node.hovering and node.built:
					if node.custom_class == "Solar":
						found = true
					else:
						stack.push_front(node)

				# FIX: Moved outside the deletion check so the index always increments accurately
	return found

func iterativeDFS_main(v, new_group_name):
	var discovered = []
	var stack = []
	stack.push_front(v)

	while len(stack) > 0:
		var s = stack[0]
		stack.pop_front()

		# FIX: The connections loop MUST be nested inside this validation block
		if typeof(s) != TYPE_INT and is_instance_valid(s) and s not in discovered:
			discovered.append(s)


			for node in s.connections:
				if typeof(node) != TYPE_INT and is_instance_valid(node) and node not in discovered and not node.hovering:
					node.remove_from_group(node.group_)
					node.group_ = new_group_name
					node.add_to_group(new_group_name)
					power_groups[new_group_name][1] += node.power_capacity
					total_capacity += node.power_capacity
					stack.push_front(node)
				# FIX: Moved outside the deletion check so the index always increments accurately


	return discovered




func hide_selection_node():
	main_scene.waiting_for_clickout = false
	selection_node.remove_from_group("selection")
	main_scene.remove_child(selection_node)
	main_scene.hide_selection_ui(tower_selected)
	tower_selection_mode = false
