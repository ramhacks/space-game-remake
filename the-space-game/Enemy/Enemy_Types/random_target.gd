extends Node
const EnemyEnums = preload("res://enums/enemy_enums.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Get_target()
## Returns two things, if found valid target returns the reference, if unable to returns command to destroy
## self, when funciton that is calling this recieves EnemyEnums.TargetFound.KILLSELF it will promptly
## destroy the enemy object
func get_target() -> Variant:
	if(get_tree().get_nodes_in_group("tower_node").size() == 0):
		get_parent().get_parent().queue_free()
		return EnemyEnums.TargetFound.KILLSELF # No other towers destroy enemy

	var targ = get_tree().get_nodes_in_group("tower_node")[randi() % get_tree().get_nodes_in_group("tower_node").size()]

	return targ
