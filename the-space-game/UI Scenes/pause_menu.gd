extends Control

signal menu_closed # connected to parent
# Exit to main menu
func _on_exit_pressed() -> void:
	get_tree().set_pause(false)
	Globals.reset_all()
	get_tree().change_scene_to_file("res://GameScenes/MainMenu.tscn")

func _on_save_pressed() -> void:
	print("Not implemented yet")
	pass # Replace with function body.


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action("BUTTON_LEFT"):
			self.hide()
			menu_closed.emit()
