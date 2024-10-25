extends Node2D

#list of towers
var mining_tower



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
		tower_to_place.position = self.get_node("Camera_Area").get_relative_mouse_pos()
		
		#the code below makes it so that we don't try and draw collidiing asteroids until the mouse is not
		#inside the hotbar anymore
		if(starting_tower_pos.y - self.get_node("Camera_Area").get_relative_mouse_pos().y > 25):
			tower_to_place.hovering = true
		

		


func _on_camera_area_cancel_spawn_tower() -> void:
	#if mouse right_clicked and currently placeing_tower cancel it
	if(placing_tower):
		tower_to_place.queue_free()
		placing_tower = false

func _on_camera_area_place_tower(cur_position: Variant) -> void:
	if(placing_tower and len(tower_to_place.get_overlapping_bodies()) != 0):
		
		Globals.resources = Globals.resources - 45
		placing_tower = false
		tower_to_place.queue_free()
		var copy = tower_scene.instantiate()
		copy.position = cur_position
			
		self.add_child(copy)
		copy.set_placed(true)
		
			
		copy.get_node("collider").visible = false	
		
		#connect laser_signal to tower so it can call it itself
		copy.draw_laser.connect(Callable(draw_laser))
			
			
			
			
		

func _on_miner_button_pressed() -> void:
	if(Globals.resources - 45 >= 0):
		
		#miner tower button pressed
		tower_scene = mining_tower
		tower_to_place = tower_scene.instantiate()
		tower_to_place.draw_laser.connect(Callable(draw_laser))
		#don't run the placed function so nothing will happen
		self.add_child(tower_to_place)
		starting_tower_pos = self.get_node("Camera_Area").get_relative_mouse_pos()
		tower_to_place.set_frame_child(tower_to_place.frame_count())
		placing_tower = true
	
	
func draw_laser(pos1, pos2, R, G, B, opacity, cooldown_time):
	#create line node 
	# 3 points, 
	#1st is self(pos1) position
	#2nd is pos2 position
	#3rd is self(pos1) position again

	var line = Line2D.new()
	var color = Color(R, G, B, opacity)

	self.add_child(line)

	line.set_default_color(color)
	line.width = 3
	
	line.add_point(to_local(pos1))
	line.add_point(to_local(pos2))
	line.add_point(to_local(pos1))
	
	
	var cooltime = Timer.new()
	self.add_child(cooltime)
	cooltime.set_wait_time(cooldown_time)
	cooltime.timeout.connect(Callable(clear_laser).bind(cooltime, line))
	cooltime.start()
		
		
		
	
	color = Color(R, G, B, cooltime.time_left/100)
		
	line.set_default_color(color)
	
	
	
	
	

	
func clear_laser(timer, line):
	timer.stop()
	line.clear_points()
	
	
	


#on timer time up, queue_free line
