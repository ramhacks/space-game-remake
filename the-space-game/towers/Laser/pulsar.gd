extends State

var custom_class


var temp_parent
var pulses = 3
var pulsing = false
# Pulsar fires much faster and uses less energy but does less damage


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func do_process(parent_node):
	#Make sure not currently pulsing but also that we have an enmey in range to attack
	if !pulsing and is_instance_valid(change_collision_list(parent_node.my_range_area.get_overlapping_bodies())):
		temp_parent = parent_node
		$PulseTimer.start()


func laser_enemy(parent):
	var target = change_collision_list(parent.my_range_area.get_overlapping_bodies())

	if is_instance_valid(target):
		draw_laser_attack(parent.to_local(parent.global_position), parent.to_local(target.global_position), parent)
		target.get_node("Hitbox").register_hit(parent, parent.custom_vars_dict["Damage"], self)



func change_collision_list(col_list):
	for enemy in col_list:
		if enemy is Enemy:
			return enemy

	return null

func draw_laser_attack(pos1, pos2, parent):
	var laser_line = parent.get_node("Laser")
	laser_line.clear_points()
	laser_line.add_point(pos1)
	laser_line.add_point(pos2)
	laser_line.add_point(pos1)
	parent.get_node("AnimationPlayer").play("laser")


# To achieve a pulse loop 3 times with a very short timer, this achieves a way to
# "Ignore" the power delay mechanic and function on our own delay, while pulsing ignore any do_process requests
# to avoid stacking of functions
func _on_pulse_timer_timeout() -> void:
	if pulses > 0:
		pulses-=1
		laser_enemy(temp_parent)
		$PulseTimer.start()
	else:
		pulses = 3
		pulsing = false
