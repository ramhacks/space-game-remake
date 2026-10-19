extends Node


var current_animation_changed = false
# Called when the node enters the scene tree for the first time.

func init_target() -> void:
	get_parent().send_change("defense")



## This can return 2 types, first would be the target if it found it
## if it could not find any target of this type it will swap to Random target selection and downgrade itself
func get_target() -> Variant:

	if(get_tree().get_nodes_in_group("defense").size() == 0):
		# Change targeting strategy to default random
		get_parent().get_parent().target_strat = "random"
		return EnemyEnums.TargetFound.SWITCH_RANDOM

	var targ = get_tree().get_nodes_in_group("defense")[randi() % get_tree().get_nodes_in_group("defense").size()]

	return targ
