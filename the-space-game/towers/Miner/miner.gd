extends AnimatedSprite2D


var tower_colliding_ob_set = false
var asteroids_in_range = []

var upgrade_level = 1  #same as parent value, miner just needs it so it knows how much it needs to mine

signal draw_line(pos1, pos2)


var closest = false
var valid = false
var current_drained

func mine(line_node):
	if closest:
	#only mine if there is a node nearby and powered
		#create mining laser graphic
		if(closest.get_resource_amount() > 0):
			closest.extract(self.get_parent().get_parent().current_upgrade_node.custom_vars_dict["Extraction per Cycle"])

		else:
			#queue behavior
			closest.asteroid_empty = true
			closest.assign_empty_texture()
				#asteroid is empty, move to next available asteroid in range
			current_drained = true
			asteroids_in_range.pop_front()
			if(len(asteroids_in_range)):
				closest = asteroids_in_range[0]
			else:
				closest = false
				#don't send laser, stop all mining operations
		if closest:
			draw_line.emit(to_local(self.global_position), to_local(closest.global_position))
		else:
			draw_line.emit(to_local(self.global_position), to_local(self.global_position))

		return self.get_parent().get_parent().current_upgrade_node.custom_vars_dict["Extraction per Cycle"]
	return 0

func change_collision_list(col_list):
	for asteroid in col_list:
		if asteroid is Asteroid:
			if asteroid.asteroid_empty == false and (asteroid not in asteroids_in_range):
				asteroids_in_range.append(asteroid)
			else:
				asteroids_in_range.erase(asteroid)

	if(len(asteroids_in_range)):
		closest = asteroids_in_range[0]

	tower_colliding_ob_set = true


func collision_list():
	return asteroids_in_range
