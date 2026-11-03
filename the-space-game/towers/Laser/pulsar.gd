extends State

var custom_class


var temp_parent
var pulses = 3
var pulsing = false

var laser_bank: int = 0
var max_bank: int = 1
# Pulsar fires much faster and uses less energy but does less damage



func do_process(parent_node):
	if !pulsing:
		if !get_parent().change_collision_list(parent_node.my_range_area.get_overlapping_bodies()) and laser_bank < max_bank:
			laser_bank += 1
			get_tree().create_timer(0.5).timeout.connect(_on_timeout.bind(parent_node))
		else:
			temp_parent = parent_node
			$PulseTimer.start()
	#REFUND POWER CANT USE IT
	else:
		#Refund energy no need to use
		if(Globals.power_groups[parent_node.group_][0]+ parent_node.current_upgrade_node.energy_needs <= Globals.power_groups[parent_node.group_][1]):
			Globals.power_groups[parent_node.group_][0] += parent_node.current_upgrade_node.energy_needs
			Globals.total_current += parent_node.current_upgrade_node.energy_needs

func _on_timeout(parent_node):
	var found = get_parent().change_collision_list(parent_node.my_range_area.get_overlapping_bodies())
	if found and !pulsing:
		$PulseTimer.start()
		laser_bank -= 1
	else:
		get_tree().create_timer(0.5).timeout.connect(_on_timeout.bind(parent_node)) # Timeout to try to shoot laser






# To achieve a pulse loop 3 times with a very short timer, this achieves a way to
# "Ignore" the power delay mechanic and function on our own delay, while pulsing ignore any do_process requests
# to avoid stacking of functions
func _on_pulse_timer_timeout() -> void:

	if pulses >= 0:
		pulses-=1
		get_parent().laser_enemy(temp_parent)
		$PulseTimer.start()
	else:
		pulses = 3
		pulsing = false
