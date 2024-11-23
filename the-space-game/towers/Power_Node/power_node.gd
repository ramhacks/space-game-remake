extends Tower

var upgrade_level = 1

var upgrade_map = {
	1: 10,
	2: -1
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_node = self.get_node("Sprite")
	child_area = self.get_node("Collision_Area")
	animated_node = self.get_node("Sprite2D")
	inherted_node = self
	sprite_texture = animated_node.get_sprite_frames().get_frame_texture(animated_node.animation, 0)
	
	place_build_progress_bar()

	super._ready()

	
	
func get_overlap():
	return [1,2,3] #placeholder as we don't need to check for overlapping asteroids, will need to check for nodes however

func _process(delta: float) -> void:
	#have to invoke super process or it wont call every frame
	super._process(delta)
