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


#var starting_resources = 200
var starting_resources = 1000

var last_deleted_tower: Node;
var tutorial_active = false

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
var wave_active = false

var selection_node

var tower_hovering = false

var tower_node_amount = 0
var NO_SOLAR_TOWER = true

var global_power_timer_on = Timer.new()
var power_on_delay = 0.5
var global_power_timer_off = Timer.new()
var power_off_delay = 0.5


var asteroid_generation_type: String;



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

func add_to_mineral_queue(mineral_change: int, target_function: Callable, failure_function: Callable):
	mineral_queue.append([mineral_change, target_function, failure_function])


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
func connect_group_lines(_self_node):
	recompute_power_totals()
	get_tree().call_group('tower_node', "reset_line")


func _process(delta: float) -> void:
	if len(mineral_queue):
		var output = mineral_queue.pop_front()

		if resources-output[0] >= 0:
			resources = resources - output[0]
			output[1].call()
		else:
			output[2].call()


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
	if not is_instance_valid(tower):
		return
	last_deleted_tower = tower
	tower.remove_from_group("Placed_Towers")

	var old_group = tower.group_
	var old_current = 0
	if power_groups.has(old_group):
		old_current = power_groups[old_group][0]
	if old_group != "NAN":
		tower.remove_from_group(old_group)

	# 1. Everyone who touches this tower (either direction)
	var neighbors = _neighbors_of(tower)

	# 2. Erase the tower from ALL neighbours BEFORE any traversal
	for t in neighbors:
		t.connections = t.connections.filter(func(n):
			return is_instance_valid(n) and _as_tower(n) != tower)

	# 3. Find the disconnected pieces, excluding the removed tower
	var visited = {}
	var components = []
	var remaining_cap = 0
	for t in neighbors:
		if visited.has(t):
			continue
		var comp = _collect_component(t, tower)
		for n in comp:
			visited[n] = true
			remaining_cap += n.power_capacity
		components.append(comp)

	# 4. One fresh, unique group per piece; split stored power by capacity
	for comp in components:
		var gid = new_group_id()
		var cap = 0
		for n in comp:
			n.convert_group(gid)
			cap += n.power_capacity
		var share = 0
		if remaining_cap > 0:
			share = int(old_current * float(cap) / remaining_cap)
		power_groups[gid] = [share, cap]

	recompute_power_totals()   # also erases empty groups (incl. old one)

	# 5. Redraw lines now (queued tower is filtered out) and once more after it's gone
	for t in neighbors:
		t.draw_tower_hover_lines()
	tower.tree_exited.connect(after_tower_freed.bind(neighbors), CONNECT_ONE_SHOT)
	tower.queue_free()

func after_tower_freed(neighbors):
	for t in neighbors:
		if is_instance_valid(t):
			t.draw_tower_hover_lines()



# Target function to fix that is causing issues
func remove_node_from_group(tower):
	if len(removal_queue) == 0:
		removal_queue.append(tower)
		advance_removal_queue()
	else:
		removal_queue.append(tower)

	return


# Undirected adjacency for all placed towers, built once per query
func _build_adjacency() -> Dictionary:
	var adj = {}
	for t in get_tree().get_nodes_in_group("Placed_Towers"):
		if is_instance_valid(t) and not t.is_queued_for_deletion():
			adj[t] = []
	for t in adj.keys():
		for c in t.connections:
			var o = _as_tower(c)
			if o and o != t and adj.has(o):
				if not adj[t].has(o): adj[t].append(o)
				if not adj[o].has(t): adj[o].append(t)
	return adj

func find_closest_solar(v) -> bool:
	if not is_instance_valid(v):
		return false
	if v.custom_class == "Solar" and not v.built:
		return true

	var adj = _build_adjacency()
	if not adj.has(v):
		adj[v] = _neighbors_of(v)

	var seen = {v: true}
	var stack = [v]
	while stack.size() > 0:
		var cur = stack.pop_back()
		for nb in adj.get(cur, []):
			if seen.has(nb) or nb.hovering or not nb.built:
				continue
			if nb.custom_class == "Solar":
				return true
			seen[nb] = true
			stack.push_back(nb)
	return false

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
				if node is Tower:
					if typeof(node) != TYPE_INT and is_instance_valid(node) and node not in discovered:
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

var next_group_id: int = 1

#AI
func new_group_id() -> String:
	while power_groups.has(str(next_group_id)) or get_tree().get_node_count_in_group(str(next_group_id)) > 0:
		next_group_id += 1
	var id = str(next_group_id)
	next_group_id += 1
	return id

# Accepts either a Tower or its sprite_collider Area, returns the Tower (or null)
func _as_tower(n):
	if not is_instance_valid(n) or n.is_queued_for_deletion():
		return null
	if n is Tower:
		return n
	var p = n.get_parent()
	if is_instance_valid(p) and p is Tower and not p.is_queued_for_deletion():
		return p
	return null

# Undirected neighbours: anyone I list, or anyone who lists me
func _neighbors_of(n, exclude = null) -> Array:
	var out = []
	for c in n.connections:
		var t = _as_tower(c)
		if t and t != exclude and t != n and not out.has(t):
			out.append(t)
	for other in get_tree().get_nodes_in_group("Placed_Towers"):
		if other == exclude or other == n or out.has(other) or not is_instance_valid(other):
			continue
		for c in other.connections:
			if _as_tower(c) == n:
				out.append(other)
				break
	return out

func _collect_component(start, exclude) -> Array:
	var seen = {start: true}
	var stack = [start]
	while stack.size() > 0:
		var cur = stack.pop_back()
		for nb in _neighbors_of(cur, exclude):
			if not seen.has(nb):
				seen[nb] = true
				stack.push_back(nb)
	return seen.keys()

# Single source of truth: derive max power and totals from actual group members
func recompute_power_totals():
	total_capacity = 0
	total_current = 0
	for g in power_groups.keys():
		var max_p = 0
		var count = 0
		for n in get_tree().get_nodes_in_group(g):
			if n is Tower and not n.is_queued_for_deletion():
				max_p += n.power_capacity
				count += 1
		if count == 0:
			power_groups.erase(g)
			continue
		power_groups[g][1] = max_p
		power_groups[g][0] = min(power_groups[g][0], max_p)
		total_capacity += max_p
		total_current += power_groups[g][0]

func merge_groups(from_g, into_g):
	if from_g == into_g or not power_groups.has(from_g) or not power_groups.has(into_g):
		return
	var cur = power_groups[from_g][0]
	for n in get_tree().get_nodes_in_group(from_g):
		n.convert_group(into_g)
	power_groups[into_g][0] += cur
	power_groups.erase(from_g)

#END AI
