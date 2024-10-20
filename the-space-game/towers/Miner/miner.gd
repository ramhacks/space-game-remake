extends Sprite2D



var asteroids_in_range = {}
var upgrade_level = 1

var upgrade_resource_drain = {
	1: 10,
	2: 20,
	3: 30
}

var closest = false
var valid = false
var current_drained

var powered = true # temporary until power is implemented


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func distance(input_vector, target_vector):
	#calculate distance between 2 points to find the smallest
	var p1 = (target_vector.x - input_vector.x)**2
	var p2 = (target_vector.y - input_vector.y)**2
	return sqrt(p1+p2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for asteroid in asteroids_in_range:
		if !closest:
			closest = asteroids_in_range[asteroid]
		else:
			if(distance(self.position, asteroids_in_range[asteroid].global_position) < distance(self.position, closest.global_position)  or current_drained):
				closest = asteroids_in_range[asteroid]
				current_drained = true
				valid = true
	

func mine(line_node):
	line_node.clear_points()
	if(valid and powered): #only mine if there is a node nearby and powered
		line_node.add_point(to_local(self.global_position))
		line_node.add_point(to_local(closest.global_position))
	
		#create mining laser graphic
		
		closest.get_node("Sprite2D").extractresources(upgrade_resource_drain[upgrade_level])		
		#print(closest, closest.get_node("Sprite2D").resources)
		if(closest.get_node("Sprite2D").resources <= 0):
			#asteroid is empty, move to next available asteroid in range
			current_drained = true
			closest.get_node("Sprite2D").assign_empty_texture()
			asteroids_in_range.erase(closest)
			valid = false
		



#when miner is powered, start to mine 
func recieve_power():
	powered = true
	
func change_collision_list(asteroids):
	if(len(asteroids_in_range) != len(asteroids)):
		asteroids_in_range = {}
		for rock in asteroids:
			asteroids_in_range[rock] = rock
