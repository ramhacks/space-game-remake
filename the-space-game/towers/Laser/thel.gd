extends State

var custom_class


var laser_bank: int = 0
var max_bank: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Exact same as basic laser as only difference for thel is damage not functionality
func do_process(parent_node):
	var found = get_parent().laser_enemy(parent_node)
	if !found and laser_bank < max_bank:
		laser_bank += 1
		get_tree().create_timer(0.5).timeout.connect(_on_timeout.bind(parent_node)) # Timeout to try to shoot laser
	else:
		#Refund energy no need to use
		if(Globals.power_groups[parent_node.group_][0]+ parent_node.current_upgrade_node.energy_needs <= Globals.power_groups[parent_node.group_][1]):
			Globals.power_groups[parent_node.group_][0] += parent_node.current_upgrade_node.energy_needs
			Globals.total_current += parent_node.current_upgrade_node.energy_needs
#Keep trying timeout, will run in the background
func _on_timeout(parent_node):
	var found = get_parent().laser_enemy(parent_node)
	if found:
		laser_bank -= 1
	else:
		get_tree().create_timer(0.5).timeout.connect(_on_timeout.bind(parent_node))
