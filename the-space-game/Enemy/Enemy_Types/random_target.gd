extends Node
var current_animation_changed = false
var random = RandomNumberGenerator.new()
func init_target() -> void:
	get_parent().send_change("random")



## Get_target()
## Returns two things, if found valid target returns the reference, if unable to returns command to destroy
## self, when funciton that is calling this recieves EnemyEnums.TargetFound.KILLSELF it will promptly
## destroy the enemy object
func get_target() -> Variant:

	random.randomize()
	print("GETTING RANDOM TARGET")
	if(get_tree().get_nodes_in_group("tower_node").size() == 0):
		get_parent().get_parent().queue_free()
		return EnemyEnums.TargetFound.KILLSELF # No other towers destroy enemy

	var targ = get_tree().get_nodes_in_group("tower_node")[randi_range(0, get_tree().get_nodes_in_group("tower_node").size() - 1)]
	print("TARGET PICKED: ", targ)
	return targ
