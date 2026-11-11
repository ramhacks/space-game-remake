extends State

var custom_class

const PULSE_COUNT := 3

var temp_parent
var pulses_left: int = PULSE_COUNT
var pulsing: bool = false

var laser_bank: int = 0
var max_bank: int = 1
# Pulsar fires much faster and uses less energy but does less damage


func do_process(parent_node):
	# Mid-pulse: we run on our own PulseTimer, so ignore the power cycle and refund
	if pulsing:
		_refund(parent_node)
		return

	var found = get_parent().change_collision_list(parent_node.my_range_area.get_overlapping_bodies())
	if found:
		_start_pulse(parent_node)
	elif laser_bank < max_bank:
		# No target yet, keep checking in the background
		laser_bank += 1
		get_tree().create_timer(0.5).timeout.connect(_on_timeout.bind(parent_node))
	else:
		# No target and already waiting on one, power isn't needed
		_refund(parent_node)


func _on_timeout(parent_node):
	# Tower was deleted/replaced while we were waiting
	if not is_instance_valid(parent_node) or not is_inside_tree():
		laser_bank = max(laser_bank - 1, 0)
		return

	var found = get_parent().change_collision_list(parent_node.my_range_area.get_overlapping_bodies())
	if found and !pulsing:
		laser_bank = max(laser_bank - 1, 0)
		_start_pulse(parent_node)
	else:
		get_tree().create_timer(0.5).timeout.connect(_on_timeout.bind(parent_node))


func _start_pulse(parent_node):
	temp_parent = parent_node
	pulses_left = PULSE_COUNT
	pulsing = true
	$PulseTimer.start()


# Fires PULSE_COUNT times on a short timer, ignoring the power delay
# while pulsing so do_process calls don't stack
func _on_pulse_timer_timeout() -> void:
	if not is_instance_valid(temp_parent) or pulses_left <= 0:
		_end_pulse()
		return

	pulses_left -= 1
	get_parent().laser_enemy(temp_parent)

	if pulses_left > 0:
		$PulseTimer.start()
	else:
		_end_pulse()


func _end_pulse():
	pulsing = false
	pulses_left = PULSE_COUNT
	temp_parent = null
	$PulseTimer.stop()


# Call this when the tower is upgraded / rebuilt so no stale state survives
func reset_state():
	_end_pulse()
	laser_bank = 0


func _exit_tree():
	$PulseTimer.stop()


func _refund(parent_node):
	if not is_instance_valid(parent_node):
		return
	var groups = Globals.power_groups
	var needs = parent_node.current_upgrade_node.energy_needs
	if groups[parent_node.group_][0] + needs <= groups[parent_node.group_][1]:
		groups[parent_node.group_][0] += needs
		Globals.total_current += needs
