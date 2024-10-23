extends Area2D

signal cancel_spawn_tower
signal place_tower(cur_position)

var cur_name = "camera"

var cam

var mouse_start_pos
var screen_start_position

var dragging = false

func _ready() -> void:
	cam = get_node("Camera2D")

func get_relative_mouse_pos():
	mouse_start_pos = get_viewport().get_mouse_position()
	#returns the mouse position relative to the camera position
	var pos_to_send = mouse_start_pos + screen_start_position
	return pos_to_send
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			
			mouse_start_pos = event.position
			screen_start_position = position
			
			if event.button_index == MOUSE_BUTTON_RIGHT:
				var pos_to_send = mouse_start_pos/cam.zoom + screen_start_position
				cancel_spawn_tower.emit()
			elif event.button_index == MOUSE_BUTTON_LEFT:
				var pos_to_send = mouse_start_pos/cam.zoom + screen_start_position
				place_tower.emit(pos_to_send)
			
			if event.button_index == 3:
				dragging = true
		else:
			dragging = false
		
		
		
		
	elif event is InputEventMouseMotion and dragging:
		position = (mouse_start_pos - event.position) + screen_start_position
	
