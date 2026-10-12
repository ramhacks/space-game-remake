extends Node2D
class_name Enemy_Missile

var move_direction

var projectile_type = "Missile"

var enemy = false

var custom_class = "Enemy_Missile"

var speed = 200
var accel = 2

@export var damage = 5

var hit_sender = self

func set_damage(damage_in):
	damage = damage_in

func set_target(target):
	enemy = target

func _physics_process(delta: float) -> void:
	if enemy:
		if is_instance_valid(enemy):
			global_position = global_position.move_toward(enemy.position, speed * delta)
		else:
			self.queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area:
		if area is Hitbox and Hitbox != hit_sender.get_node("Hitbox"):
			area.register_hit(hit_sender, damage, self)
