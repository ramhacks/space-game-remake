extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_target():
	randomize()
	
	
	
	
	var targ = get_tree().get_nodes_in_group("tower_node")[randi() % get_tree().get_nodes_in_group("tower_node").size()]
	
	
	return targ
