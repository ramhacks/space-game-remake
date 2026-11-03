extends Node2D

@export var initial_state: State


var reset_ = false
var current_state : State
var states : Dictionary = {}
var parent_node: Tower
var laser_line: Line2D


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)

	if initial_state:
		current_state = initial_state


func _process(delta) -> void:
	if current_state:
		current_state.Update(delta)




func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return

	var new_state = states.get(new_state_name.to_lower())

	if !new_state:
		return

	if current_state:
		current_state.Exit()

	new_state.Enter()

	current_state = new_state


func _on_laser_tower_built() -> void:
	if current_state:
		current_state.do_process(parent_node)

func laser_enemy(parent) -> bool:
	var target = change_collision_list(parent.my_range_area.get_overlapping_bodies())
	var damage = parent.current_upgrade_node.custom_vars_dict["Damage"]
	if is_instance_valid(target):
		draw_laser_attack(parent.to_local(parent.global_position), parent.to_local(target.global_position), parent)
		target.get_node("Hitbox").register_hit(parent, damage, self)
		return true
	else:
		#Couldnt find any enemies but also check if found an enemy tower instead
		target = change_collision_list(parent.enemy_towers())
		if is_instance_valid(target):
			draw_laser_attack(parent.to_local(parent.global_position), parent.to_local(target.global_position), parent)

			target.get_node("Hitbox").register_hit(parent, damage, self)
			return true
	return false

func change_collision_list(col_list):
	for enemy in col_list:
		if enemy is Enemy:
			return enemy
		elif enemy.get_parent().is_in_group("EnemyTowers"):
			return enemy.get_parent()

	return null

func draw_laser_attack(pos1, pos2, parent):
	var _line = parent.get_node("Laser")
	_line.clear_points()
	_line.add_point(pos1)
	_line.add_point(pos2)
	_line.add_point(pos1)
	parent.get_node("AnimationPlayer").play("laser")
