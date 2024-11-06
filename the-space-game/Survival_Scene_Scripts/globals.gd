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

var resources = 250 # amount of resources the current player has
var RPM = 0

var tower_selection_mode = false
var tower_selected
