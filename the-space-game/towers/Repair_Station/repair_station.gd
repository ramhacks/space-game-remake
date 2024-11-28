extends Tower

#Until laser is added this will be a laser tower
class_name Repair_Station



var projectile_type = "Laser"
var mis


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
		laser_enemy() #temporary for testing purposes
	super.do_process()


#Transfer to laser node when implemented
func laser_enemy():
	var target = change_collision_list($Collision_Area.get_overlapping_bodies())
	if is_instance_valid(target):
		draw_laser_attack(to_local(self.global_position), to_local(target.global_position))
		target.get_node("Hitbox").register_hit(self, 20) 



func change_collision_list(col_list):
	for enemy in col_list:
		if enemy is Enemy:
			return enemy
	
	return null
	
func draw_laser_attack(pos1, pos2):
	var line = $Laser

	line.clear_points()
	line.add_point(pos1)
	line.add_point(pos2)
	line.add_point(pos1)
	self.get_node("AnimationPlayer").play("laser") 
	
func get_overlap():
	return [1,2,3] #placeholder as we don't need to check for overlapping asteroids, will need to check for nodes however
