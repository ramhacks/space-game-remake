extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Steps
# get all tower nodes in a list
# extract necessary varaibles from tower nodes such as well everything and put them in a dictionary:
	#

var tower_instance_dict: Dictionary = {
	"health_connected": false,
	"enabled": false,
	"killed": false,
	"line_node_connections": [],
	"radar_marker": null,
	"no_power_animation_on": false,
	"powered": true,
	"set_power": false,
	"child_area": null,
	"sprite_node": null,
	"animated_node": null,
	"inherted_node": null,
	"built_connected": false,
	"connection_points": [],
	"connected_to_node_freed": false,
	"group_": "",
	"power_capacity": 0,
	"power_time_seconds":0,
	"connections": [],
	"sent_": 0,
	"show_colliding_asteroids": false,
	"overlap_areas": 0,
	"build_progress": 0,
	"built": false,
	"set_build_frame": false,
	"cooldown_delay": 3,
	"cooling_down": false,
	"line_node": false,
	"hovering": false,
	"clickable": false,
	"on_object": false,
	"sprite_texture": null,
	"past_connection_amount": 0,
	"circle_instance": null,
	"current_upgrade_node": null,
	"upgrade_reference": null # Stores the dynamic reference path, not the reference itself,
								#For example if I have a node that is level 2 solar, then we will
								# store the variable name, level 2 solar
								# then we will get the actual node of that via dict_path in
								# current_upgrade_node after initization

}

#Array of tower_instance_dicts that we can easily write to a file

var tower_data_dict = {}
func _on_save_pressed() -> void:

	#Get valid towers
	var valid_towers = get_tree().get_nodes_in_group("tower_node")
	for tower_ref in valid_towers:
		#set connections
		tower_ref.connections = tower_ref.connections.map(func(r): return str(r))

		tower_data_dict[str(tower_ref)] = {
			"health_connected": false,
			"enabled": false,
			"killed": false,
			"line_node_connections": [],
			"radar_marker": null,
			"no_power_animation_on": false,
			"powered": true,
			"set_power": false,
			"child_area": null,
			"sprite_node": null,
			"animated_node": null,
			"inherted_node": null,
			"built_connected": false,
			"connection_points": [],
			"connected_to_node_freed": false,
			"group_": "",
			"power_capacity": 0,
			"power_time_seconds":0,
			"connections": [],
			"sent_": 0,
			"show_colliding_asteroids": false,
			"overlap_areas": 0,
			"build_progress": 0,
			"built": false,
			"set_build_frame": false,
			"cooldown_delay": 3,
			"cooling_down": false,
			"line_node": false,
			"hovering": false,
			"clickable": false,
			"on_object": false,
			"sprite_texture": null,
			"past_connection_amount": 0,
			"circle_instance": null,
			"current_upgrade_node": null,
			"upgrade_reference": null
		}


	pass
