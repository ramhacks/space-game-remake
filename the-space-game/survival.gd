extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var scene = preload("res://Asteroid_Gen/asteroid_field.tscn")
	var tower = preload("res://towers/miner.tscn")
	var instance = scene.instantiate()
	var ins = tower.instantiate()
	self.add_child(instance)

	self.add_child(ins)
	
	
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
