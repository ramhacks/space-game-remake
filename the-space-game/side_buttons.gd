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
	if(Globals.tower_selection_mode and (Globals.resources >= Globals.tower_selected.upgrade_price[Globals.tower_selected.level])):
		Globals.resources -= Globals.tower_selected.upgrade_price[Globals.tower_selected.level]
		Globals.tower_selected.level += 1
		if(Globals.tower_selected.upgrade_price[Globals.tower_selected.level] == -1):
			self.remove_child($Upgrade_Button)
		else:
			$Upgrade_Button.text = "Upgrade: " + str(Globals.tower_selected.upgrade_price[Globals.tower_selected.level])
			
		Globals.tower_selected.built = true #change to false when power is implmented
		
		Globals.tower_selected.build_progress = 0
		Globals.tower_selected.child.play("level" + str(Globals.tower_selected.level))
		


func _on_recycle_pressed() -> void:
	recycle_pressed = true
	Globals.resources += Globals.tower_selected.recycle_price[Globals.tower_selected.level]
	hide_selection.emit()
	
func _on_survival_finished() -> void:
	if(recycle_pressed):
		Globals.tower_selected.queue_free()
		recycle_pressed = false
		Globals.tower_selected = false
