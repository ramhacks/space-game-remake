extends Area2D


var cur_name = "miner"

var timer #temporary



var cooldown_timer
var cooldown_delay = 1.5 #may need to be adjusted based on upgrade level
var cooling_down = false


var line_node

var child

var hovering = false #hovering next to mouse, not placed yet
#assumed false until told otherwise

var powered = false #is this node powered? once set to true it will mine once


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	child = self.get_node("Sprite2D")
	
	timer = self.get_node("Timer") #The timer is in place of a power node, when we implement power, we won't need a timer
	timer.set_wait_time(2)

	
	line_node = self.get_node("Mining_Laser")
	cooldown_timer = self.get_node("Cooldown")
	cooldown_timer.set_wait_time(cooldown_delay)
	
func set_placed(re_animate):  #required for all towers
	hovering = false
	if(re_animate):
		child.frame = 0
	#this function is so when we press the button to place a tower and we just want to show the tower being placed
	#we won't activate this function so it will not activate the tower, only show it
		child.placed = true
		
	timer.start() #start mining functionality, will be removed once we implement power
	

func set_frame_child(frame): #required for all towers
	child.frame = frame
	
func frame_count(): #required for all towers
	return child.sprite_frames.get_frame_count("place")
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if hovering:
		line_node.clear_points()
		var overlap = self.get_overlapping_bodies()
		for body in overlap:
			
			#loop through all overlapping bodies and create a line from the miner
			#to the bodies
			line_node.add_point(to_local(self.global_position))
			line_node.add_point(to_local(body.global_position))
			line_node.add_point(to_local(self.global_position))
	
	

	
#this function will be replaced with a signal from the power node connecting it to the power grid. Each power node
#will relay a signal until it gets to this, for now we are just using a timer
func _on_timer_timeout() -> void:	 
	if(!cooling_down):
		#if powered mine, else on the next 2 sec cycle delete the mining laser graphic
		
		child = self.get_node("Sprite2D")
		if(child):
			child.mine(line_node)
		
		cooling_down = true
		cooldown_timer.start()
	
	


func _on_body_entered(body: Node2D) -> void:
	if body.cur_name == "asteroid":
		if body.get_resource_amount() > 0:
			#only add if asteroid is not empty of resources
			child.change_collision_list(body)


func collision_list():
	return child.asteroids_in_range

func _on_cooldown_timeout() -> void:
	#when the mining lasers cooldown is finished, we are available to mine when we recieve another power
	#pulse, (for now it means we are available to mine when the timer is 0)
	#this makes it so that it is not overpowered and has a mining time limit
	line_node.clear_points()
	cooling_down = false
	timer.start()
