extends Control

var tower_data_pull
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.tower_selection_mode:
		modify_text(tower_data_pull)

func modify_text(tower_data):
	if(tower_data.custom_class == "Miner"):
		$Label1.text = "Mine Amount: " + str(tower_data.current_upgrade_node.custom_var)
		$Label2.text = "Total Mined: " + str(tower_data.total_mined)

	elif(tower_data.custom_class == "Solar"):
		$Label1.text = "Energy Rate: " + str(tower_data.current_upgrade_node.custom_var_2)
		$Label2.text = "Rest Time: " + str(tower_data.current_upgrade_node.custom_var)
		$Label2.visible = false
