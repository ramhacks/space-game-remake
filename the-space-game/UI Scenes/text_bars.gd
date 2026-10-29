extends Control

var tower_data_pull
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.tower_selection_mode:
		modify_text(tower_data_pull)

func dict_to_string(d: Dictionary) -> String:
	var lines = PackedStringArray()
	for key in d:
		lines.append("%s: %s" % [key, d[key]])
	return "\n".join(lines)

func modify_text(tower_data):
	#print(dict_to_string(tower_data.current_upgrade_node.custom_vars_dict))
	$Label1.text = dict_to_string(tower_data.current_upgrade_node.custom_vars_dict)

	$Label2.text = "Energy Required: " + str(tower_data.current_upgrade_node.energy_needs)
	if(tower_data.custom_class == "Miner"):
		$Label3.text = "Total Mined: " + str(tower_data.total_mined)
