extends State

var custom_class

var basic_damage = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

	
func do_process(parent_node):
	laser_enemy(parent_node)
	
#Transfer to laser node when implemented
func laser_enemy(parent):

	var target = change_collision_list(parent.my_range_area.get_overlapping_bodies())
	
	if is_instance_valid(target):
		draw_laser_attack(parent.to_local(parent.global_position), parent.to_local(target.global_position), parent)
		target.get_node("Hitbox").register_hit(parent, basic_damage, self) 



func change_collision_list(col_list):
	for enemy in col_list:
		if enemy is Enemy:
			return enemy
	
	return null
	
func draw_laser_attack(pos1, pos2, parent):
	var laser_line = parent.get_node("Laser")
	laser_line.clear_points()
	laser_line.add_point(pos1)
	laser_line.add_point(pos2)
	laser_line.add_point(pos1)
	parent.get_node("AnimationPlayer").play("laser") 
	
