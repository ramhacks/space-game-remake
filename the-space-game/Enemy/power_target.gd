extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_target():
	if(get_tree().get_nodes_in_group("power").size() == 0):
		get_parent().get_parent().queue_free()
		return null
		
		
		
	var targ = get_tree().get_nodes_in_group("power")[randi() % get_tree().get_nodes_in_group("power").size()]
	
	return targ
