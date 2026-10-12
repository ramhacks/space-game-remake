extends TextureButton


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().set_pause(true)

		Globals.pause_game()
	else:
		get_tree().set_pause(false)
		Globals.restart_game()
