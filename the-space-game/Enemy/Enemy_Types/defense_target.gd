extends Node
const EnemyEnums = preload("res://enums/enemy_enums.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## This can return 2 types, first would be the target if it found it
## if it could not find any target of this type it will swap to Random target selection and downgrade itself
func get_target() -> Variant:

	if(get_tree().get_nodes_in_group("defense").size() == 0):
		# Change targeting strategy to default random
		get_parent().get_parent().target_strat = "Random"
		return EnemyEnums.TargetFound.SWITCH_RANDOM

	var targ = get_tree().get_nodes_in_group("defense")[randi() % get_tree().get_nodes_in_group("defense").size()]

	return targ
