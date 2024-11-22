extends Sprite2D

@export var minimap_x_size: int
@export var minimap_y_size: int

func on_update_location(loc):
	loc = to_local(loc)
	self.visible = true

	loc.x /= (225)
	loc.y /= (227)
	self.position = loc 
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
