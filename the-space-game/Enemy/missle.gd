extends Node2D
class_name Enemy_Missile

var move_direction
@onready var nav = $NavigationAgent2D
var enemy = false

var speed = 200
var accel = 2
var damage = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_target(target):
	enemy = target

	

func _physics_process(delta: float) -> void:
	if enemy:
		if is_instance_valid(enemy):
			global_position = global_position.move_toward(enemy.position, speed * delta)
		else:
			self.queue_free()
#

func _on_area_2d_area_entered(area: Area2D) -> void:
	self.queue_free()
