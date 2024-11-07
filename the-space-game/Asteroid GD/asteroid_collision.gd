extends StaticBody2D


var cur_name = "asteroid"
var asteroid_empty = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.set_random_size()
	if(get_resource_amount() == 0):
		$Sprite2D.set_random_size()
	$Sprite2D.assign_full_texture()
	var radius = $Sprite2D.texture.get_size().x/2
	$CollisionShape2D.shape.set_radius(radius)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func extract(amount):
	var sprite = self.get_node("Sprite2D")
	sprite.extractresources(amount)
	

func get_resource_amount():
	var sprite = self.get_node("Sprite2D")
	return sprite.resources

func assign_empty_texture():
	var sprite = self.get_node("Sprite2D")
	sprite.assign_empty_texture()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action("BUTTON_LEFT"):
			print(get_resource_amount())
