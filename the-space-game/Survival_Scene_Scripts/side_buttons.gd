extends VBoxContainer

signal hide_selection

var recycle_pressed = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Globals.tower_selection_mode):
		pass

var temp_tower_targ;
var child_target_index;
func continue_upgrade() -> void:
	temp_tower_targ.level += 1

	temp_tower_targ.current_upgrade_node = temp_tower_targ.current_upgrade_node.children[child_target_index]
	if len(temp_tower_targ.current_upgrade_node.children) > 0:
		self.remove_child($Custom)

		$Upgrade_Button.text = temp_tower_targ.current_upgrade_node.children[0].label
		$Recycle.text = "Recycle: " + str(temp_tower_targ.current_upgrade_node.recycle_price)

	else:
		self.remove_child($Custom)
		self.remove_child($Upgrade_Button)



	temp_tower_targ.built = false #change to false when power is implmented

	temp_tower_targ.get_node("BuildProgress").visible = true

	temp_tower_targ.build_progress = 0

	temp_tower_targ.animated_node.play(temp_tower_targ.current_upgrade_node.label)


	if temp_tower_targ is not Laser:
		temp_tower_targ.upgrade(null)
	else:
		#Make an exception on what upgrade button they pressed as there would be 2 options
		temp_tower_targ.upgrade(temp_tower_targ.current_upgrade_node.label) #Change parameter to type, either thel or pulsar

	temp_tower_targ.get_node("Health").set_health(temp_tower_targ.current_upgrade_node.health)

func process_upgrade(upgrade_label):
	var can_upgrade: bool

	temp_tower_targ = Globals.tower_selected
	#print(tower_targ.current_upgrade_node.children)
	child_target_index = temp_tower_targ.current_upgrade_node.children_names.find(upgrade_label)
	var price = temp_tower_targ.current_upgrade_node.children[child_target_index].price

	if Globals.tower_selection_mode:
		Globals.add_to_mineral_queue(price, continue_upgrade)






func _on_recycle_pressed() -> void:
	recycle_pressed = true
	Globals.resources += Globals.tower_selected.current_upgrade_node.recycle_price
	hide_selection.emit()

func _on_survival_finished() -> void:
	if(recycle_pressed):
		recycle_pressed = false
		Globals.tower_selected = false



func _on_custom_upgrade_pressed(label: Variant) -> void:
	process_upgrade(label)

func _on_upgrade_button_upgrade_pressed(label: Variant) -> void:
	process_upgrade(label)
