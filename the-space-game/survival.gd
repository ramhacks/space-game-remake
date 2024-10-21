extends Node2D

var tower

var cur_name = "camera"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var asteroid_scene = preload("res://Asteroid_Gen/asteroid_field.tscn")
	var instance = asteroid_scene.instantiate()
	self.add_child(instance)
	#temporary just to test miner tower
	
	tower = preload("res://towers/Miner/miner.tscn")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.get_node("CanvasLayer/Resources").text = str(Globals.resources)


	


func _on_area_2d_spawn_tower(type: Variant, pos: Variant) -> void:

	var miner = tower.instantiate()
	miner.position = pos
	self.add_child(miner)
