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
var selection_node

var starting_tower_pos
var activate_nearby_node_showing = false

func clear_hover_lines():
	#fix so that you can't place tower in hotbar
	var hover_line_node = get_tree().get_nodes_in_group("hover_line")[0]
	
	hover_line_node.queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var asteroid_scene = preload("res://Asteroid_Gen/asteroid_field.tscn")
	selection_node = preload("res://Selection_Draw_Node/Selection_Draw.tscn").instantiate()
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
	if(placing_tower and len(tower_to_place.get_overlapping_bodies()) != 0 && (starting_tower_pos.y - self.get_node("Camera_Area").get_relative_mouse_pos(false).y > 30)):
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
		copy.draw_selection_animation.connect(draw_selector)
			
			
			
			
		

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
	
	
func draw_laser(tower, pos1, pos2, cooldown_time, tower_origin):
	#create line node 
	# 3 points, 
	#1st is self(pos1) position
	#2nd is pos2 position
	#3rd is self(pos1) position again
	var line = tower.get_node("Laser")
	
	line.clear_points()
	self.add_child(line)
	line.add_point(pos1)
	line.add_point(pos2)
	line.add_point(pos1)
	tower.get_node("AnimationPlayer").play("line_disolve") 
	
	
	#at some point replace below with just a check if animation is finished or not, when finished just set cooldown to false
	var cooltime = Timer.new()
	self.add_child(cooltime)
	cooltime.set_wait_time(cooldown_time)
	cooltime.timeout.connect(Callable(clear_laser).bind(cooltime, tower_origin))
	cooltime.start()
		
		
		
	
	#color = Color(R, G, B, cooltime.time_left/100)
		
	#line.set_default_color(color)
	
func clear_laser(timer, tower_origin):
	#this is on a separate branch because I do not know
	#how to attach animations to nodes that are created during runtime
	
	#tower origin is so we can tell the tower that called to draw a laser that the cooldown after firing is up and it
	#can resume normal activities
	timer.stop()
	#line.clear_points()
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
	var draw = true
	for nodes in pos2_list:
		#only draw line (only applies to miner class) if asteroid is not empty of resources
		if(nodes.cur_name == "asteroid"):
			if(nodes.asteroid_empty):
				draw = false
			else:
				draw = true
		
			#only draw line (only applies to miner class) if asteroid is not empty of resources
		if(nodes.cur_name == "asteroid"):
			if(nodes.asteroid_empty):
				draw = false
			else:
				draw = true
		
		if draw:
			line_node.add_point(to_local(pos1))
			line_node.add_point(to_local(nodes.global_position))
			line_node.add_point(to_local(pos1))

var waiting_for_clickout = false


func draw_selector(tower_pos, tower_radius, clicked_self): #if add, add else play tween then remove
	#draw the selection animation, we will add a tween after finishing creating the base selection shape
	if(clicked_self and selection_node not in get_tree().get_nodes_in_group("selection")): #only draw if clicked node
		#it has been clicked so now if somewhere that is not this node is clicked hide the select drawing
		self.add_child(selection_node)
		selection_node.add_to_group("selection")
		selection_node.position = tower_pos
		selection_node.redraw_self(tower_radius)
		#create tween to animate
		var tween = self.get_tree().create_tween() #rotate the drawing 
		tween.tween_property(selection_node, "rotation", deg_to_rad(-90), 0.5)	
		tween.finished.connect(tween_done.bind(clicked_self))
		
	elif(waiting_for_clickout and selection_node in get_tree().get_nodes_in_group("selection")):
		var tween = self.get_tree().create_tween() #rotate the drawing 
		tween.tween_property(selection_node, "rotation", deg_to_rad(90), 0.5)
		tween.finished.connect(tween_done.bind(false))
		
func tween_done(create):
	if create:
		waiting_for_clickout = true
	else:
		selection_node.remove_from_group("selection")
		self.remove_child(selection_node)
		waiting_for_clickout = false

	
	
