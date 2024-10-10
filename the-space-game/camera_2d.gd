extends Camera2D
class_name MainCamera

var _target_zoom: float = 1.0

const MIN_ZOOM: float = 1.5
const MAX_ZOOM: float = 4
const ZOOM_INCREMENT: float = 0.2

const ZOOM_RATE: float = 8.0
var mouse_start_pos
var screen_start_position

var dragging = false




func _input(event):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
		
		
			
		if event.button_index == MOUSE_BUTTON_WHEEL_UP: #If scroll up, zoom
			self.zoom.x +=0.5
			self.zoom.y +=0.5
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN: #If scroll down, dezoom
			#zoom_out()
			self.zoom.x-=0.5
			self.zoom.y-=0.5
		
		
	elif event is InputEventMouseMotion and dragging:
		print("drag")
		position = (mouse_start_pos - event.position)/zoom + screen_start_position
	
