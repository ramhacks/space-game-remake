extends Tower

#Until laser is added this will be a laser tower
class_name Missile_Launcher

signal tower_built

var projectile_type = "Missile"
var mis




var my_range_base_shape
var my_range_shape
var my_range_area

#Set up and general use functions
# =========================================================

#For creating the range area it is allowed to interact with, has to be dynamically added so it doesn't change
#the range of all nodes, this is used to see what nodes we can attack
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
	mis = preload("res://Enemy/missle.tscn")
	inherted_node = self
	show_colliding_bodies = true
	var current_animation : String = animated_node.animation

	set_range_area()

	sprite_texture = animated_node.get_sprite_frames().get_frame_texture(current_animation, 0)

	place_build_progress_bar()




	super._ready()

func return_local(pos):
	return to_local(pos)

func get_overlap():
	return [1,2,3] #placeholder as we don't need to check for overlapping asteroids, will need to check for nodes however

# =========================================================




#Functions used during the course of this nodes existence


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	super._process(delta)

func do_process():
	if built:


		self.power_time_seconds = 2


		tower_built.emit()

		#Each missile is worth its damage amount divided by 3
		if Globals.resources >= (self.current_upgrade_node.custom_var / 3):

			Globals.resources = Globals.resources - (self.current_upgrade_node.custom_var / 3)
			send_missile()


	super.do_process()



#Transfer to laser node when implemented
func send_missile():

	var target = change_collision_list(my_range_area.get_overlapping_bodies())
	if is_instance_valid(target):
		var out = mis.instantiate()
		out.custom_class = "Player_"
		out.damage = current_upgrade_node.custom_var

		self.add_child(out)
		out.set_target(target)


#Look for an enemy target in range
func change_collision_list(col_list):
	for enemy in col_list:
		if enemy is Enemy:
			return enemy

	return null

func upgrade(upgrade_type):
	pass
