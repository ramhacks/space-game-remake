extends Area2D

class_name Hitbox



@export var health_component: Health
@export var parent: Node2D

@export var radius_inherit: Area2D
@export var shape_: CollisionShape2D

@export var dynamic_Area: bool

#hit types can be either enemy or player
#The hit_type determines what this projectile is targeting, if it is going to target a player it will set its 
#hit_type to player if it is targeting enemy it will set its hit_type to enemy, its hit_type may also be a specific class for example
#this hitbox may only accept projectiles of type enemy_missle. Then its hit_types will be enemy missile
#Hit type is an array of what classes this hitbox registers
@export var hit_types: Array


#Make it so that you can use the hitbox in any scenario, make it so you can choose if you are selecting an area or a direct collision shape


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if dynamic_Area:
		$CollisionShape2D.shape.radius = radius_inherit.get_node("CollisionShape2D").shape.radius + 1
	else:
		$CollisionShape2D.shape.radius = shape_.shape.radius + 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func register_hit(sender, damage, missile):
	if sender.custom_class in hit_types:
		health_component.health_amount -= damage
		if sender.projectile_type == 'Missile':
			missile.queue_free()

		

	
