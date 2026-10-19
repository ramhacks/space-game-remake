extends Tower

#Until laser is added this will be a laser tower
class_name Repair_Station

var my_range_base_shape
var my_range_shape
var my_range_area



#For creating the range area it is allowed to interact with, has to be dynamically added so it doesn't change
#the range of all nodes, this is used to see what nodes we can repair
func set_range_area():
	my_range_base_shape = CircleShape2D.new()
	my_range_shape = CollisionShape2D.new()
	my_range_base_shape.radius = self.current_upgrade_node.custom_var_2
	my_range_shape.shape = my_range_base_shape

	my_range_area = Area2D.new()
	my_range_area.collision_layer = pow(2, 2-1) + pow(2, 4-1)
	my_range_area.collision_mask = pow(2, 1-1) + pow(2, 3-1)
	self.add_child(my_range_area)
	my_range_area.add_child(my_range_shape)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_node = self.get_node("Sprite")
	child_area = self.get_node("Collision_Area")
	animated_node = self.get_node("Sprite_Node/Sprite2D")

	inherted_node = self
	var current_animation : String = animated_node.animation

	sprite_texture = animated_node.get_sprite_frames().get_frame_texture(current_animation, 0)

	place_build_progress_bar()
	set_range_area()
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

func upgrade(upgrade_type):
	set_range_area()
