extends Area2D


#copy of parent variables so that when traversing the graph we can access properties of parent
var correct_area = true
var hovering = false
var built = false
var visited = false
var powered = false

var my_name
var connections = []

signal set_powered_val()
signal ask_for_colliding_areas(sprite_pointer)
signal reset_powers()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite_texture
	var node = get_tree().root
	var found = false
	var children = Globals.get_all_children(node)
	
	var radius
	for tree_node in children:
		if tree_node is AnimatedSprite2D:
			found = true

			assert("hover" in tree_node.sprite_frames.get_animation_names(), "No hover animation for this tower exists! (You need to name at least one animation 'hover')")
			
			radius = tree_node.get_sprite_frames().get_frame_texture('hover', 0).get_size().x/2
			self.get_child(0).shape.set_radius(radius)
			
			
			
	
	
	assert (found, "You forgot to name your AnimatedSprite2D node in your new tower Sprite2D!")
	
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func set_val():
	set_powered_val.emit()
	
func reset_power():
	reset_powers.emit()
	
func get_colliding():
	ask_for_colliding_areas.emit(self)
	
