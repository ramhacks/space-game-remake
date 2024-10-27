extends Control
#draws the selection animation

var draw_position = Vector2(0,0) #default values
var radius = 9.3905
var width = 0.8
var white : Color = Color.WHITE

var angle_list = [0, 90, 180, 270]

var line_change

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func redraw_self(r):
	self.size = Vector2(r*2,r*2) #set size and scale so that the node is not stretched
	self.scale = Vector2(1,1)

	radius = r
	
	var r2 = radius/3 #length of corner lines
	line_change = { #can't make it before this because the dict needs to be set with the new radius
		0: [Vector2(-r2, 0), Vector2(r2, 0)],
		90: [Vector2(0, -r2), Vector2(0, r2)],
		180: [Vector2(-r2, 0), Vector2(r2, 0)],
		270: [Vector2(0, -r2), Vector2(0, r2)]
	}
	
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func float_array_to_Vector2Array(coords : Array) -> PackedVector2Array:
	# Convert the array of floats into a PackedVector2Array.
	var array : PackedVector2Array = []
	for coord in coords:
		array.append(Vector2(coord[0], coord[1]))
	return array

	
func _draw():
	#draw a circle around itself, will edit lines that go on it later
	self.draw_circle(draw_position, radius, white, false, width)
	
	

	
	
	for angle in line_change:
		#4 marks
		#get angle_positions on line(will be center of line)
		var circle_point = Vector2(radius*cos(deg_to_rad(angle)), radius*sin(deg_to_rad(angle)))

		
		var plotpoints = []
		for pos in line_change[angle]:
			plotpoints.append(pos + circle_point) #find a way to optimize this, don't want this to be O(n^2) time
		
		self.draw_line(plotpoints[0], plotpoints[1], white)
	
	#self.draw_line()
	

	
	
