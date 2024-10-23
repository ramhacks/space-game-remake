extends Area2D


var cur_name = "miner"

var timer

var line_node

var child

var hovering = false #hovering next to mouse, not placed yet
#assumed false until told otherwise

var powered = false #is this node powered? once set to true it will mine once


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	child = self.get_node("Sprite2D")
	timer = self.get_node("Timer")
	timer.set_wait_time(2)
	
	line_node = self.get_node("Mining_Laser")
	
func set_placed(re_animate):  #required for all towers
	hovering = false
	if(re_animate):
		child.frame = 0
	#this function is so when we press the button to place a tower and we just want to show the tower being placed
	#we won't activate this function so it will not activate the tower, only show it
		child.placed = true
		
	timer.start() #start mining functionality

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
	
	

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		#simulate the node getting power can change to any signal
		powered = true
	
	

func _on_timer_timeout() -> void:	
	#if powered mine, else on the next 2 sec cycle delete the mining laser graphic
	if(!powered):
		line_node.clear_points()
		powered = true #remove 
		
	else:
		child = self.get_node("Sprite2D")
		if(child):
			child.mine(line_node)
		powered = false
	timer.start()
	


func _on_body_entered(body: Node2D) -> void:
	if body.cur_name == "asteroid":
		if body.get_resource_amount() > 0:
			#only add if asteroid is not empty of resources
			child.change_collision_list(body)


func collision_list():
	return child.asteroids_in_range
