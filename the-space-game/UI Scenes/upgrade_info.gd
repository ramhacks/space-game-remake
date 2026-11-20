extends Control

var tower_selected
var upgrade_label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_side_buttons_hide_upgrade_info() -> void:
	hide()


func _on_side_buttons_show_upgrade_info() -> void:
	show()
	$Panel/VBoxContainer/UpgradeName.text = "Upgrade Name: " + str(tower_selected.current_upgrade_node.children[0].label)
	var first_section = Globals.dict_to_string(tower_selected.current_upgrade_node.children[0].custom_vars_dict, tower_selected.custom_class)
	if tower_selected.custom_class != "Solar" and tower_selected.custom_class != "Battery":
		$Panel/VBoxContainer/UpgradeInfo.text = first_section + "\nEnergy Required " + str(tower_selected.current_upgrade_node.children[0].energy_needs)
	else:
		$Panel/VBoxContainer/UpgradeInfo.text = first_section


func _on_survival_send_selected_tower(tower: Variant, label: Variant) -> void:
	tower_selected = tower
	upgrade_label = label
