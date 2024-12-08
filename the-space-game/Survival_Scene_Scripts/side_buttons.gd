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


func _on_upgrade_button_pressed() -> void:
	process_upgrade($Custom)

func process_upgrade(upgrade_label):
	var can_upgrade: bool
	
	var tower_targ = Globals.tower_selected
	var child_target_index = tower_targ.current_upgrade_node.children_names.find(tower_targ.current_upgrade_node.label)
	var price = tower_targ.current_upgrade_node.children[child_target_index].price
	
	can_upgrade = Globals.tower_selection_mode and (Globals.resources >= price)
	#
	#if(Globals.tower_selected is not Laser):
		#can_upgrade = Globals.tower_selection_mode and (Globals.resources >= Globals.tower_selected.upgrade_price[Globals.tower_selected.level])
		#
	#else:
		##Thel Upgrade Price is 100
		#can_upgrade = Globals.tower_selection_mode and (Globals.tower_selected.pulsar_upgrade_price_map[Globals.tower_selected.level])
		
	if(can_upgrade):
		
		Globals.resources -= price
		tower_targ.level += 1
		
		tower_targ.current_upgrade_node = tower_targ.current_upgrade_node.children[child_target_index]
		
		if len(tower_targ.current_upgrade_node.children) > 0:
			self.remove_child($Custom)
			$Upgrade_Button.text = tower_targ.current_upgrade_node.children[0].label
			$Recycle.text = "Recycle: " + str(tower_targ.current_upgrade_node.recycle_price)
			
		else:
			self.remove_child($Custom)
			self.remove_child($Upgrade_Button)
		
		

		tower_targ.built = false #change to false when power is implmented
		
		tower_targ.get_node("BuildProgress").visible = true
		
		tower_targ.build_progress = 0
		
		tower_targ.animated_node.play(tower_targ.current_upgrade_node.label)
		print(tower_targ.current_upgrade_node.label)
		
		
		if tower_targ is not Laser:
			tower_targ.upgrade(null)
		else:
			#Make an exception on what upgrade button they pressed as there would be 2 options
			tower_targ.upgrade(tower_targ.current_upgrade_node.label) #Change parameter to type, either thel or pulsar
		
		tower_targ.get_node("Health").health_amount = tower_targ.current_upgrade_node.health
		tower_targ.get_node("Health").max_health = tower_targ.current_upgrade_node.health



func _on_recycle_pressed() -> void:
	recycle_pressed = true
	Globals.resources += Globals.tower_selected.current_upgrade_node.recycle_price
	hide_selection.emit()
	
func _on_survival_finished() -> void:
	if(recycle_pressed):
		recycle_pressed = false
		Globals.tower_selected = false


func _on_custom_pressed() -> void:
	process_upgrade($Upgrade_Button)
