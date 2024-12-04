extends Tower

#Until laser is added this will be a laser tower
class_name Repair_Station



var upgrade_level = 1

var upgrade_map = {
	1: 10,
	2: -1
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_node = self.get_node("Sprite")
	child_area = self.get_node("Collision_Area")
	animated_node = self.get_node("Sprite_Node/Sprite2D")
	
	inherted_node = self
	show_colliding_bodies = true
	var current_animation : String = animated_node.animation
	
	sprite_texture = animated_node.get_sprite_frames().get_frame_texture(current_animation, 0)
	
	place_build_progress_bar()
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	super._process(delta)

func do_process():
	if built:
		pass
	super.do_process()



func get_overlap():
	return [1,2,3] #placeholder as we don't need to check for overlapping asteroids, will need to check for nodes however
