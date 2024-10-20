extends Node2D

#global variables below:





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var scene = preload("res://Asteroid_Gen/asteroid_field.tscn")
	var instance = scene.instantiate()
	self.add_child(instance)
	#temporary just to test miner tower
	
	var tower = preload("res://towers/Miner/miner.tscn")
	var miner = tower.instantiate()
	self.add_child(miner)
	
	
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.get_node("CanvasLayer/Resources").text = str(Globals.resources)
