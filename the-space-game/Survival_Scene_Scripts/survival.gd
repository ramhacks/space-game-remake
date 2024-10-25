extends Node2D

#list of towers
var mining_tower

signal finished_cooldown

signal connect_game_ticks(node)

#these two variables are if we are going to place a tower, press the tower button and show the tower following
#the mouse and then what type of tower we are placing, the functionality of the towers will be the same for 
#most towers but has a few exceptions we will implement at a later point
var placing_tower = false
var tower_to_place
var tower_scene

var game_tick_timer


var starting_tower_pos
var activate_nearby_node_showing = false

func clear_hover_lines():
	var hover_line_node = get_tree().get_nodes_in_group("hover_line")[1]
	hover_line_node.queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var asteroid_scene = preload("res://Asteroid_Gen/asteroid_field.tscn")
	var instance = asteroid_scene.instantiate()
	self.add_child(instance)
	#temporary just to test miner tower
	
	mining_tower = preload("res://towers/Miner/miner.tscn")
	
	game_tick_timer = get_node("Global_Ticks")


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.get_node("HotBar_Layer/ColorRect2/Right Box/Resources").text = str(Globals.resources) + " minerals"
	if(placing_tower):
		tower_to_place.position = self.get_node("Camera_Area").get_relative_mouse_pos(false)
		
		#the code below makes it so that we don't try and draw collidiing asteroids until the mouse is not
		#inside the hotbar anymore
		if(starting_tower_pos.y - self.get_node("Camera_Area").get_relative_mouse_pos(false).y > 25):
			tower_to_place.hovering = true
		

		


func _on_camera_area_cancel_spawn_tower() -> void:
	#if mouse right_clicked and currently placeing_tower cancel it
	if(placing_tower):
		clear_hover_lines()
		tower_to_place.queue_free()
		placing_tower = false

func _on_camera_area_place_tower(cur_position: Variant) -> void:
	if(placing_tower and len(tower_to_place.get_overlapping_bodies()) != 0):
		clear_hover_lines()
		
		Globals.resources = Globals.resources - 45
		placing_tower = false
		tower_to_place.queue_free()
		var copy = tower_scene.instantiate()
		copy.position = cur_position
			
		self.add_child(copy)
		copy.set_placed(true)
		
			
		copy.get_node("collider").visible = false	
		
		#connect laser_signal to tower so it can call it itself
		copy.draw_laser.connect(draw_laser)
		
			
			
			
			
		

func _on_miner_button_pressed() -> void:
	if(Globals.resources - 45 >= 0):
		
		#miner tower button pressed
		tower_scene = mining_tower  
		tower_to_place = tower_scene.instantiate() #create a temporary tower object, will be deleted and replaced once placed
		
		tower_to_place.draw_hover_line.connect(hover_line)
		#don't run the placed function so nothing will happen
		self.add_child(tower_to_place)
		starting_tower_pos = self.get_node("Camera_Area").get_relative_mouse_pos(false)
		tower_to_place.set_frame_child(tower_to_place.frame_count())
		placing_tower = true
	
	
func draw_laser(pos1, pos2, R, G, B, opacity, cooldown_time, tower_origin):
	#create line node 
	# 3 points, 
	#1st is self(pos1) position
	#2nd is pos2 position
	#3rd is self(pos1) position again

	var line = Line2D.new()
	var color = Color(R, G, B, 1)

	self.add_child(line)

	line.set_default_color(color)
	line.width = 3
	
	line.add_point(to_local(pos1))
	line.add_point(to_local(pos2))
	line.add_point(to_local(pos1))
	
	
	var cooltime = Timer.new()
	self.add_child(cooltime)
	cooltime.set_wait_time(cooldown_time)
	cooltime.timeout.connect(Callable(clear_laser).bind(cooltime, line, tower_origin))
	cooltime.start()
		
		
		
	
	#color = Color(R, G, B, cooltime.time_left/100)
		
	#line.set_default_color(color)
	
func clear_laser(timer, line, tower_origin):
	#tower origin is so we can tell the tower that called to draw a laser that the cooldown after firing is up and it
	#can resume normal activities
	timer.stop()
	line.clear_points()
	line.queue_free()
	timer.queue_free()
	tower_origin.cooling_down = false
	
	tower_origin.timer.start() #remove after power is implmeneted
	
	
func hover_line(pos1, pos2_list, R, G, B, opacity, line_node):
	line_node.add_to_group("hover_line")
	line_node.clear_points()
	var color = Color(R, G, B, opacity)
	self.add_child(line_node)
	line_node.set_default_color(color)
	line_node.width = 3
	for nodes in pos2_list:
		line_node.add_point(to_local(pos1))
		line_node.add_point(to_local(nodes.global_position))
		line_node.add_point(to_local(pos1))
	
	
