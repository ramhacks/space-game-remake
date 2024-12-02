extends Sprite2D

class_name Radar
signal get_relative(location)

var new_target_pos: Vector2

@export var minimap_x_size: int
@export var minimap_y_size: int

var rel


# y = 0.894x


# -254y + 227x + 0 = 0
# X2 Y2   X3   Y3
# (0,0), (227, 254)
func receive_relative(loc):
	rel = loc
	
	
func reflect_over_line(p, q):
	var x2 = 127
	var y2 = 1
	var x3 = 128
	var y3 = 227
	var m = (y3-y2)/(x3-x2)
	var c = (x3*y2-x2*y3)/(x3-x2)
	
	var d = (p + (q-c)*m)/(1+m**2)
	
	var outx = 2*d - p
	var outy = 2*d*m - q + 2*c
	
	return Vector2(outx, outy)
	
	
	
#Move the radar node, this is called for all radar node groups once the frame delay timer is up, as of now
#this is called every 10 frames
func move_radar_marker():
	
	if(new_target_pos.x < 250 and new_target_pos.y < 227 and new_target_pos.x > 0 and new_target_pos.y > 0):
		self.visible = true
		self.position = new_target_pos

	else:
		self.visible = false
		
func on_update_location(loc):

	#get_relative.emit(loc)
	#loc = rel
	loc.x *= (254.0/1152.0) 
	loc.y *= (227.0/648.0)
	
	#loc = reflect_over_line(loc.x, loc.y)
	

	new_target_pos = loc #We are storing this so that when we can update the position we update it to the most recent
	#position we recieved
	
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
