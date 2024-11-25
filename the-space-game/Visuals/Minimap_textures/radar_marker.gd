extends Sprite2D

class_name Radar
signal get_relative(location)

@export var minimap_x_size: int
@export var minimap_y_size: int
var rel

func receive_relative(loc):
	rel = loc
	
func on_update_location(loc):
	get_relative.emit(loc)
	loc = rel
	loc.x *= (254.0/1152.0) 
	loc.y *= (227.0/648.0)
	
	loc.x = 254 - loc.x
	loc.y = 227 - loc.y
	
	if(loc.x < 250 and loc.y < 227 and loc.x > 0 and loc.y > 0):
		self.visible = true
		self.position = loc 
	else:
		self.visible = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
