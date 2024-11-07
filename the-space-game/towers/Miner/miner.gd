extends AnimatedSprite2D


var tower_colliding_ob_set = false
var asteroids_in_range = []

var upgrade_level = 1  #same as parent value, miner just needs it so it knows how much it needs to mine

signal draw_line(pos1, pos2)


var upgrade_map = {
	1: 10,
	2: 20
}

var closest = false
var valid = false

var placed = false #required for all towers

var current_drained



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !closest:
		self.frame = 0 
	if placed:
		self.frame = 1
		self.play("place")
		placed = false
		#when ready run animation only once then stop

	

func mine(line_node):
	if closest:
	#only mine if there is a node nearby and powered
		#create mining laser graphic
		if(closest.cur_name == "asteroid"):
			if(closest.get_resource_amount() > 0):	
				closest.extract(upgrade_map[upgrade_level])		
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
					self.frame = 0 #set as having no power, in this case having no more asteroids to mine
					closest = false
					
					
					return #don't send laser, stop all mining operations
					
			draw_line.emit(to_local(self.global_position), to_local(closest.global_position))	


func change_collision_list(col_list):
	for asteroid in col_list:
		if asteroid.cur_name == "asteroid":
			if asteroid.asteroid_empty == false:
				asteroids_in_range.append(asteroid)
				
	if(len(asteroids_in_range)): 
		closest = asteroids_in_range[0]
		
	tower_colliding_ob_set = true	
func collision_list():
	return asteroids_in_range


	
		
