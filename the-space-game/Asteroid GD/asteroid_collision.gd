extends StaticBody2D


var cur_name = "asteroid"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
