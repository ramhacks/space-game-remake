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
	var can_upgrade: bool
	if(Globals.tower_selected is not Laser):
		can_upgrade = Globals.tower_selection_mode and (Globals.resources >= Globals.tower_selected.upgrade_price[Globals.tower_selected.level])
		
	else:
		#Thel Upgrade Price is 100
		can_upgrade = Globals.tower_selection_mode and (Globals.tower_selected.pulsar_upgrade_price_map[Globals.tower_selected.level])
		
	if(can_upgrade):
		Globals.resources -= Globals.tower_selected.upgrade_price[Globals.tower_selected.level]
		Globals.tower_selected.level += 1
		if(Globals.tower_selected.upgrade_price[Globals.tower_selected.level] == -1):
			self.remove_child($Upgrade_Button)
		else:
			$Upgrade_Button.text = "Upgrade: " + str(Globals.tower_selected.upgrade_price[Globals.tower_selected.level])
			
		Globals.tower_selected.built = false #change to false when power is implmented
		
		Globals.tower_selected.get_node("BuildProgress").visible = true
		
		Globals.tower_selected.build_progress = 0
		Globals.tower_selected.animated_node.frame = 1
		if Globals.tower_selected is not Laser:
			Globals.tower_selected.animated_node.play("level" + str(Globals.tower_selected.level))
			Globals.tower_selected.upgrade(null)
		else:
			#Make an exception on what upgrade button they pressed as there would be 2 options
			Globals.tower_selected.upgrade("Pulsar") #Change parameter to type, either thel or pulsar
		
		


func _on_recycle_pressed() -> void:
	recycle_pressed = true
	Globals.resources += Globals.tower_selected.recycle_price[Globals.tower_selected.level]
	hide_selection.emit()
	
func _on_survival_finished() -> void:
	if(recycle_pressed):
		recycle_pressed = false
		Globals.tower_selected = false


func _on_custom_pressed() -> void:
	if Globals.tower_selected is Laser:
		if(Globals.tower_selection_mode and (Globals.resources >= Globals.tower_selected.thel_upgrade_price_map[Globals.tower_selected.level])):
			#This button is to upgrade to Thel
			Globals.resources -= Globals.tower_selected.upgrade_price[Globals.tower_selected.level]
			Globals.tower_selected.level += 1
			if(Globals.tower_selected.upgrade_price[Globals.tower_selected.level] == -1):
				self.remove_child($Upgrade_Button)
			else:
				$Upgrade_Button.text = "Upgrade: " + str(Globals.tower_selected.upgrade_price[Globals.tower_selected.level])
				
			Globals.tower_selected.built = false #change to false when power is implmented
			
			Globals.tower_selected.get_node("BuildProgress").visible = true
			
			Globals.tower_selected.build_progress = 0
			Globals.tower_selected.animated_node.frame = 1
			Globals.tower_selected.upgrade("Thel")
