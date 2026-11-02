extends State

var custom_class

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



func do_process(parent_node):
	laser_enemy(parent_node)

#Transfer to laser node when implemented
func laser_enemy(parent):
	var target = change_collision_list(parent.my_range_area.get_overlapping_bodies())
	var damage = parent.current_upgrade_node.custom_vars_dict["Damage"]
	if is_instance_valid(target):
		draw_laser_attack(parent.to_local(parent.global_position), parent.to_local(target.global_position), parent)
		target.get_node("Hitbox").register_hit(parent, damage, self)
	else:
		#Couldnt find any enemies but also check if found an enemy tower instead
		target = change_collision_list(parent.enemy_towers())
		if is_instance_valid(target):
			draw_laser_attack(parent.to_local(parent.global_position), parent.to_local(target.global_position), parent)

			target.get_node("Hitbox").register_hit(parent, damage, self)



func change_collision_list(col_list):
	for enemy in col_list:
		if enemy is Enemy:
			return enemy
		elif enemy.get_parent().is_in_group("EnemyTowers"):
			return enemy.get_parent()

	return null

func draw_laser_attack(pos1, pos2, parent):
	var laser_line = parent.get_node("Laser")
	laser_line.clear_points()
	laser_line.add_point(pos1)
	laser_line.add_point(pos2)
	laser_line.add_point(pos1)
	parent.get_node("AnimationPlayer").play("laser")
