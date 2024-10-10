extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene = preload("res://Asteroid_Gen/asteroid_field.tscn")
	var instance = scene.instantiate()
	self.add_child(instance)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
