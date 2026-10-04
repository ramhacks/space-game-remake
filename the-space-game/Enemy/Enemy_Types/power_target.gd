extends Node
const EnemyEnums = preload("res://enums/enemy_enums.gd")

# Called when the node enters the scene tree for the first time.

func init_target() -> void:
	get_parent().send_change("power")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_target() -> Variant:
	if(get_tree().get_nodes_in_group("power").size() == 0):
		get_parent().get_parent().target_strat = "random"
		return EnemyEnums.TargetFound.SWITCH_RANDOM

	var targ = get_tree().get_nodes_in_group("power")[randi() % get_tree().get_nodes_in_group("power").size()]

	return targ
