extends Area2D

var correct_area = false
signal cancel_spawn_tower
signal place_tower(cur_position)
signal draw_select(tower_pos, tower_radius, clicked_self)
signal send_rel(loc)
signal hide_info_boxes

var cur_name = "camera"

var cam

var mouse_start_pos 
var screen_start_position = position


var dragging = false

var button_move_amount = 10 #amount camera will move when moved by arrow keys

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	cam = get_node("Camera2D")

func get_relative_mouse_pos(event_pos):
	#don't edit, below is a edge case when we don't have an event pos -----------------
	var pos_to_send

	#returns the mouse position relative to the camera position
	if(!event_pos):
		event_pos = Vector2(0,0)
		#this is for when we are placing a tower, for this we don't have an event position so we remove it from the equation
		mouse_start_pos = get_viewport().get_mouse_position()
		screen_start_position = position
	
	#----------------------------	
	pos_to_send = (mouse_start_pos - event_pos) + screen_start_position #equation that manages everything, add zoom here by modifying equation 
	return pos_to_send
	
func call_rel(loc):
	send_rel.emit(loc + screen_start_position)
	
func _input(event):
	get_tree().call_group("tower_node", "move_minimap_icon")
	if (event is InputEventMouseButton) or event.is_action("Middle_Button"):
		if event.is_pressed():
			mouse_start_pos = get_viewport().get_mouse_position()
			
			screen_start_position = position
			dragging = true
		else:
			dragging = false
			
	elif event is InputEventMouseMotion and dragging:
		position = get_relative_mouse_pos(event.position)
	
	if event.is_action("BUTTON_RIGHT"):
		cancel_spawn_tower.emit()
		
	if event.is_action("BUTTON_LEFT"):
		place_tower.emit(get_relative_mouse_pos(false))
	
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			get_tree().paused = !get_tree().paused


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:		
		if event.is_action("BUTTON_LEFT"):
			hide_info_boxes.emit()
			draw_select.emit(Vector2(0,0), 1, false, false) 
