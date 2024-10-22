extends AnimatedSprite2D



var asteroids_in_range = []
var upgrade_level = 1

var upgrade_resource_drain = {
	1: 10,
	2: 20,
	3: 30
}

var closest = false
var valid = false

var placed = false #required for all towers

var current_drained


signal force_change_collision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if placed:
		self.play("place")
		placed = false
		#when ready run animation only once then stop
	

func mine(line_node):
	if closest:
	#only mine if there is a node nearby and powered
		#create mining laser graphic
		if(closest.cur_name == "asteroid"):
			if(closest.get_resource_amount() > 0):
				line_node.add_point(to_local(self.global_position))
				line_node.add_point(to_local(closest.global_position))
				closest.extract(upgrade_resource_drain[upgrade_level])		
			#print(closest, closest.get_node("Sprite2D").resources)
				if(closest.get_resource_amount() <= 0):
					#asteroid is empty, move to next available asteroid in range
					current_drained = true
					asteroids_in_range.pop_back()
					if(len(asteroids_in_range)):
						closest = asteroids_in_range[0]
					else:
						force_change_collision.emit()
						closest = false
				
		
		



#when miner is powered, start to mine 

	
func change_collision_list(asteroids):
	closest = asteroids
	asteroids_in_range.append(asteroids)
		
		
	
	
	
		
