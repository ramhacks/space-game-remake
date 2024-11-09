extends Node



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

var NO_SOLAR_TOWER = true 

var global_power_timer_on = Timer.new()  
var global_power_timer_off = Timer.new()

#manage power timers so solar stations are all synced
func _ready():  
	global_power_timer_on.one_shot = true
	global_power_timer_off.one_shot = true
	global_power_timer_off.timeout.connect(start_on)
	global_power_timer_on.timeout.connect(start_off)
	
	add_child(global_power_timer_on)  
	add_child(global_power_timer_off)  
	global_power_timer_on.start(2)  

func start_off(): 
	global_power_timer_off.start(2)
	
func start_on():
	global_power_timer_on.start(2)  
	
