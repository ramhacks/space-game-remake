extends TextureButton


# When space is pressed pause the game
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		button_pressed = !button_pressed
		_on_toggled(button_pressed)

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_child(0).show()
		get_child(0).menu_closed.connect(restart)
		get_tree().set_pause(true)

		Globals.pause_game()
	else:
		get_child(0).hide()
		get_tree().set_pause(false)
		Globals.restart_game()

func restart():
	_on_toggled(false)
	button_pressed = false


## Simulate button presses on, however do not display the pause menu
func _on_info_hover_activate_pause() -> void:
	button_pressed = true
	_on_toggled(true)


func _on_info_hover_de_activate_pause() -> void:
	button_pressed = false
	_on_toggled(false)


func _on_tutorial_disable_pause() -> void:
	disabled = true


func _on_tutorial_enable_pause() -> void:
	disabled = false
