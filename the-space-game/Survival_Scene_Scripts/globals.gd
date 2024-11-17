extends Node

var power_groups = {} # 'group_name': [current_power, max_power, line_connecting_group, points]
#the points contains the points the 'line' should visit, this will help us keep track of what nodes are in the group
#they are in pairs, meant to have the line jump between pairs and not be down the whole time, think of each pair as a separete segment of the line,
#together they are a line however when making the line they may not be in order and if you follow the order with a pen down,
#you will end up with a different line all together

#This will only ever hold global variables, maybe functions but it is 
#not recommended unless absolutly necessary
func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr
	
func GetAllTreeNodes(node , listOfAllNodesInTree): #recursive
	listOfAllNodesInTree.append(node)
	for childNode in node.get_children():
		GetAllTreeNodes(childNode, listOfAllNodesInTree)
	return listOfAllNodesInTree

var resources = 2500 # amount of resources the current player has
var RPM = 0

var tower_selection_mode = false
var tower_selected

var tower_hovering = false

var tower_node_amount = 0
var NO_SOLAR_TOWER = true 

var global_power_timer_on = Timer.new() 
var power_on_delay = 0.5 
var global_power_timer_off = Timer.new()
var power_off_delay = 0.5


var power_lines

var power_line_segment
#manage power timers so solar stations are all synced
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

func start_off(): 
	global_power_timer_off.start()
	
func start_on():
	global_power_timer_on.start()  
	
	
#IMPORTANT, connects them based on group only, if not in group wont connect line between a group at all
func connect_group_lines(self_node):
	for power in power_groups:
		get_tree().call_group(power, "reset_line")
		for node in get_tree().get_nodes_in_group(power):
			for target in get_tree().get_nodes_in_group(power):
				if(node.global_position.distance_to(target.global_position) <= 58 and target != node and target not in node.line_node_connections and 
					node not in target.line_node_connections):
					node.line_node_connections.append(target)
					target.line_node_connections.append(node)
						
					node.add_local_point(node.global_position)
					node.add_local_point(target.global_position)


	
	
#Draw power node lines to direct power through
