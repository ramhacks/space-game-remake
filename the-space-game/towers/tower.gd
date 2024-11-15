extends Node2D

class_name Tower

	

var child_area
var sprite_node
var animated_node
var inherted_node #for methods that require the inhereted node
var sprite_var_node_holder

var level = 1

#ENERGY VARS
var closest_solar_station
var connections = []
var sent_nodes = []
var sent_ = false
var powered = false 
var overlap_areas = []

var power_drain = 15 #amount of power the tower uses


var show_colliding_bodies = false

@export var health = 300

var build_progress = 0 #percantage up to 100
var built = false #we will set this to false when we implement power
var set_build_frame = false



var hover_line = Line2D.new()  #hover line node pointer



signal draw_laser(tower, pos1, pos2, cooldown_time, tower_origin)
signal draw_hover_line(pos1, pos2_list, R, G, B, opacity, line_node)
signal draw_selection_animation(tower_pos, tower_radius, clicked_self, tower_type)


@export var cur_name = "tower name" #used if we want to identify the type of tower 

var cooldown_delay = 3  #may need to be adjusted based on upgrade level
var cooling_down = false

var line_node

var hovering = false #hovering next to mouse, not placed yet
#assumed false until told otherwise



var clickable = false #this is so that we don't think the tower is being clicked after we place it down

var on_object = false #if sprite itself is on asteroid don't let the player place the tower

var sprite_texture #used to get radius and height of sprite to draw selection animation and place build_progress_bar



@export var upgrade_price = {
	1: 100,
	2: -1,
	3: -1
}

@export var recycle_price = {
	1: 45,
	2: 45,
	3: 45
}



#node names are not preserved when instantced in a different scene only for nodes in the same scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set child node static variables
	sprite_var_node_holder = $Sprite
	$Sprite.my_name = cur_name
	place_build_progress_bar()
	

func place_build_progress_bar(): 
	$BuildProgress.position.y = $BuildProgress.position.y - (sprite_texture.get_size().y/2) - 2
	
	


		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#set child node and self dynamic variables
	$Sprite.hovering = hovering
	$Sprite.built = built
	animated_node.upgrade_level = level
	overlap_areas = $Sprite.get_overlapping_areas()
	#-------------------
	
	if(len(sprite_node.get_overlapping_areas()) > 0):
		on_object = true
	else:
		on_object = false
		
	if hovering:
		send_hover_line()
		draw_tower_hover_lines()
		
	if build_progress == 100 and !built and !set_build_frame:
		self.get_node("BuildProgress").set_visible(false)
		built = true
	else:
		self.get_node("BuildProgress").value = build_progress

#Build function when upgrading, resets build progress
func rebuild():
	print("rebuild")
	build_progress = 0
	built = false
	self.get_node("BuildProgress").set_visible(true)
	self.get_node("BuildProgress").value = 0 #reset value
	
	
#Hover functionality
#-----------------------------------------------------------------

func send_hover_line():
	if(show_colliding_bodies):
		if(len(sprite_node.get_overlapping_bodies()) > 0):
			on_object = true
		else:
			on_object = false
				
		var overlap = child_area.get_overlapping_bodies()
		draw_hover_line.emit(self.global_position, overlap, 0.192, 0.988, 0.165, 3, hover_line)

#traw thin blue power lines to overlapping towers
func draw_tower_hover_lines():
	$Sprite.connections = []
	$Sprite.connections = $Collision_Area.get_overlapping_areas()
	$Connector.clear_points()
	for node in $Sprite.connections:
		if is_instance_valid(node) and node.correct_area:
			$Connector.add_point(to_local(self.global_position))
			$Connector.add_point(to_local(node.global_position))	



#Functions that tend to be overloaded by inherted towers
#-----------------------------------------------------------------

func set_placed(re_animate, current_overlapping_bodies):  #required for all towers

	$Sprite.connections = overlap_areas
	for node in overlap_areas:
		print(node.my_name)
	$Connector.clear_points()
	$Connector.format_connection_lines(overlap_areas)
	
	hovering = false
	if(re_animate):
	#this function is so when we press the button to place a tower and we just want to show the tower being placed
	#we won't activate this function so it will not activate the tower, only show it
		animated_node.placed = true
	

	animated_node.play("place")
	
	animated_node.animation_finished.connect(Callable(set_clickable))

	
func set_clickable():
	clickable = true

func set_frame_child(frame): #required for all towers
	animated_node.frame = frame
	
func frame_count(): #required for all towers
	return animated_node.sprite_frames.get_frame_count("place")

func colliding_areas():
	return len(sprite_node.get_overlapping_areas()) + len(sprite_node.get_overlapping_bodies()) #all overlapping objects

func do_process():
	if not built and build_progress < 100:
		build_progress += 20
	
func get_areas_overlap():
	return child_area.get_overlapping_areas()

func get_sprite_overlap():
	return $Sprite.get_overlapping_areas()
	
func upgrade():
	pass
	
func get_overlap():
	return [1,2,3] #placeholder as we don't need to check for overlapping asteroids, will need to check for nodes however


#-----------------------------------------------------------------

	
	

#Signals recieved functions 
#-----------------------------------------------------------------

func _on_sprite_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and clickable:
		if event.is_action("BUTTON_LEFT"):
			draw_selection_animation.emit(self.global_position, sprite_texture.get_size().x/2, true,  inherted_node)
			#will change the hot bar or something to let us upgrade the selected tower

#power on
func _on_sprite_set_powered_val() -> void:
	inherted_node.do_process()
	self.powered = true
	
func _on_sprite_2d_draw_line(pos1: Variant, pos2: Variant) -> void:
	cooling_down = true
	draw_laser.emit(self, pos1, pos2, cooldown_delay, self) 
	#we can't use tweens because tweens are meant for single animations
	#we need to animate 2 things at once so we have to use attached line node and can't dynamically create one


func find_closest_solar():
	iterativeDFS($Sprite)
	print(closest_solar_station)
	
	
func iterativeDFS(v):
	var discovered = []
	# create a stack used to do iterative DFS
	var stack = []
 
	# push the source node into the stack
	stack.push_front(v)
 
	# loop till stack is empty
	while len(stack) > 0:
		# Pop a vertex from the stack
		var s = stack[0] 
		stack.pop_front()
 		
		if (s not in discovered): 
			discovered.append(s)
		# if the vertex is already discovered yet, ignore it
		
		var test_statment: bool = (s.my_name != 'solar' and s.built and s.correct_area)
		


			
		for node in s.connections: 

			if (node not in discovered and is_instance_valid(node)): 
				node.get_colliding()
				if(is_instance_valid(node) and node.correct_area and not node.hovering):
					if(node.my_name == 'solar'):
						closest_solar_station = node
						stack =[]
						break
					stack.push_front(node) 
						#---------------------------------------------------------
				else:
					pass
						



 
