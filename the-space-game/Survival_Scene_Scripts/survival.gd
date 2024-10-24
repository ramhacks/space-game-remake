extends Node2D

#list of towers
var mining_tower




#these two variables are if we are going to place a tower, press the tower button and show the tower following
#the mouse and then what type of tower we are placing, the functionality of the towers will be the same for 
#most towers but has a few exceptions we will implement at a later point
var placing_tower = false
var tower_to_place
var tower_scene


var starting_tower_pos
var activate_nearby_node_showing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var asteroid_scene = preload("res://Asteroid_Gen/asteroid_field.tscn")
	var instance = asteroid_scene.instantiate()
	self.add_child(instance)
	#temporary just to test miner tower
	
	mining_tower = preload("res://towers/Miner/miner.tscn")


	
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
	if(placing_tower):
		Globals.resources = Globals.resources - 45
		if len(tower_to_place.collision_list()) != 0:
			placing_tower = false
			tower_to_place.queue_free()
			var copy = tower_scene.instantiate()
			copy.position = cur_position
			
			self.add_child(copy)
			copy.set_placed(true)
			if copy.cur_name == "miner":
				if(len(copy.collision_list()) == 0):
					#if no collision try again just to make test collison bounds
					copy.queue_free()
					copy = tower_scene.instantiate()
					copy.position = cur_position
					
					self.add_child(copy)
					copy.set_placed(true)
			
			copy.get_node("collider").visible = false		
		

func _on_miner_button_pressed() -> void:
	if(Globals.resources - 45 >= 0):
		
		#miner tower button pressed
		tower_scene = mining_tower
		tower_to_place = tower_scene.instantiate()
		
		#don't run the placed function so nothing will happen
		self.add_child(tower_to_place)
		starting_tower_pos = self.get_node("Camera_Area").get_relative_mouse_pos()
		tower_to_place.set_frame_child(tower_to_place.frame_count())
		placing_tower = true
	
