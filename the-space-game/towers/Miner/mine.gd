extends Area2D



var cur_name = "miner"

var timer #temporary

var hover_line = Line2D.new()  #hover line node pointer

signal draw_laser(pos1, pos2, R, G, B, opacity, cooldown_time, tower_origin)
signal draw_hover_line(pos1, pos2_list, R, G, B, opacity, line_node)

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
		
		var overlap = self.get_overlapping_bodies()
		draw_hover_line.emit(self.global_position, overlap, 0.192, 0.988, 0.165, 3, hover_line)
		
		
		


		
	
	

	
#this function will be replaced with a signal from the power node connecting it to the power grid. Each power node
#will relay a signal until it gets to this, for now we are just using a timer
func _on_timer_timeout() -> void:	 
	if(!cooling_down):
		#if powered mine, else on the next 2 sec cycle delete the mining laser graphic
		
		child = self.get_node("Sprite2D")
		if(child):
			child.mine(line_node)
		
		cooling_down = true

	
	


func _on_body_entered(body: Node2D) -> void:
	if body.cur_name == "asteroid":
		if body.get_resource_amount() > 0:
			#only add if asteroid is not empty of resources
			child.change_collision_list(body)


func collision_list():
	return child.asteroids_in_range



func _on_sprite_2d_draw_line(pos1: Variant, pos2: Variant) -> void:
	cooling_down = true
	draw_laser.emit(pos1, pos2, 0.192, 0.988, 0.165, 3, 3, self)
	
