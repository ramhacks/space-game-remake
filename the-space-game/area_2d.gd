extends Area2D

signal spawn_tower(type, pos)


var cam

var mouse_start_pos
var screen_start_position

var dragging = false

func _ready() -> void:
	cam = get_node("Camera2D")

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			
			
			mouse_start_pos = event.position
			screen_start_position = position
			
			if event.button_index == MOUSE_BUTTON_LEFT:
				var pos_to_send = mouse_start_pos/cam.zoom + screen_start_position
				spawn_tower.emit("miner", pos_to_send)
			
			if event.button_index == 3:
				dragging = true
		else:
			dragging = false
		
		
		
		
	elif event is InputEventMouseMotion and dragging:
		position = (mouse_start_pos - event.position) + screen_start_position
	
