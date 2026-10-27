extends Node

class_name Path_Node

var children: Array
var children_names: Array

var health: int
var custom_var #can be damage, mining amount, power generation delay etc, depends on node
var custom_var_2
var custom_var_3

var energy_needs: int
var label: String
var price: int
var recycle_price: int
var wave_unlocked: int

# Dict of custom vars, will be custom for each tower so it can be labeled.
# This node is completly generic so does not know the names as the tower defines those
var custom_vars_dict = {}

func __init__(health_in, energy_in, label_in, upgrade_price_in, recycle_in, custom_var_dict_, wave_unlocked_in=null):
	health = health_in

	energy_needs = energy_in
	label = label_in
	price = upgrade_price_in
	recycle_price = recycle_in


	if wave_unlocked_in:
		wave_unlocked = wave_unlocked_in

	custom_vars_dict = custom_var_dict_


func add_child_path(child):
	children.append(child)
	children_names.append(child.label)
