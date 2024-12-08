extends Node

class_name Path_Node

var children: Array
var children_names: Array

var health: int
var custom_var #can be damage, mining amount, power generation delay etc, depends on node 
var custom_var_2

var energy_needs: int
var label: String
var price: int
var recycle_price: int


func __init__(health_in, energy_in, label_in, upgrade_price_in, recycle_in, custom_var_in=null,custom_var_2_in=null):
	health = health_in
	
	energy_needs = energy_in
	label = label_in
	price = upgrade_price_in
	recycle_price = recycle_in
	
	custom_var = custom_var_in
	custom_var_2 = custom_var_2_in
	

func add_child_path(child):
	children.append(child)
	children_names.append(child.label)
