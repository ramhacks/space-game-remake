extends Area2D

signal cancel_spawn_tower
signal place_tower(cur_position)

var cur_name = "camera"

var cam

var mouse_start_pos
var screen_start_position

var dragging = false

var button_move_amount = 10 #amount camera will move when moved by arrow keys

func _ready() -> void:
	cam = get_node("Camera2D")

func get_relative_mouse_pos():
	mouse_start_pos = get_viewport().get_mouse_position()
	#returns the mouse position relative to the camera position
	var pos_to_send = mouse_start_pos + screen_start_position
	return pos_to_send
	
	
func _input(event):
	if event.is_action("move_left"):
		position.x -= button_move_amount
	if event.is_action("move_right"):
		position.x += button_move_amount
	if event.is_action("move_up"):
		position.y -= button_move_amount
	if event.is_action("move_down"):
		position.y += button_move_amount
	
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
			
			# if event.button_index == 3:
			if event.is_action_pressed("ALT"):
				dragging = true
		else:
			dragging = false
		
		
		
		
	elif event is InputEventMouseMotion and dragging:
		position = (mouse_start_pos - event.position) + screen_start_position
	
	
