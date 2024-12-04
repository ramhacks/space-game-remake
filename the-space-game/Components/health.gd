extends Node

class_name Health

@export var health_amount = 100 #current health
var max_health  #maxium amount of health this node can have

@export var death_animation: AnimatedSprite2D
@export var death_animation_name: String
@export var parent: Node2D

@export var Animated_Target: Sprite_Image

var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = health_amount
	parent.get_node("Hitbox").health_component = self
	death_animation.animation_finished.connect(_on_explosion_animation_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Animated_Target:
		if health_amount <= 0 and not is_dead:	
			died()
			is_dead = true

func died():
	Animated_Target.get_node("Sprite2D").visible = false
	death_animation.play(death_animation_name)
	death_animation.visible = true

	
	

func _on_explosion_animation_finished() -> void:
	if Globals.tower_selected == parent:
		if(Globals.tower_selection_mode):
			Globals.hide_selection_node()
		
	
	parent.radar_marker.queue_free()
	Globals.tower_node_amount -= 1
	
	if parent is Tower:
		parent.remove_from_group(parent.group_)
		Globals.remove_node_from_group(parent)
		parent.sprite_var_node_holder.correct_area = false
		
		Globals.connect_group_lines(parent)
	parent.queue_free()
