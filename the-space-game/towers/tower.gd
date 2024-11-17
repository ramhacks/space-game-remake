extends Node2D

class_name Tower

var line_node_connections = []
 #what group this node belongs to

var child_area
var sprite_node
var animated_node
var inherted_node #for methods that require the inhereted node
var sprite_var_node_holder
var my_collding_radius #so we don't have to call deeper into the node to check this towers collider 

var level = 1

#ENERGY VARS
var connection_points = [] 
#list of connections to other nodes via global position, will be used by each groups line connector to connect
# each node to eachother
var group_
var power_capacity = 1
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


func reset_line():
	$Connector.clear_points()
	line_node_connections = []
#node names are not preserved when instantced in a different scene only for nodes in the same scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set child node static variables
	sprite_var_node_holder = $Sprite
	my_collding_radius = $Collision_Area
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
	overlap_areas = $Collision_Area.get_overlapping_areas()
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
func draw_tower_hover_lines(input_array=false):
	$Sprite.connections = []
	$Sprite.connections = $Collision_Area.get_overlapping_areas()
	connections = $Collision_Area.get_overlapping_areas()
	$Connector.clear_points()
	
	var loop_array
	if input_array:
		connection_points.append(self.global_position)
		loop_array = input_array
	else:
		loop_array = $Sprite.connections
		
	for node in loop_array:
		if is_instance_valid(node) and node.correct_area:
			$Connector.add_point(to_local(self.global_position))
			$Connector.add_point(to_local(node.global_position))	
			if input_array:
				connection_points.append(node.global_position)

				
				
#Functions that tend to be overloaded by inherted towers
#-----------------------------------------------------------------

func set_placed(re_animate, current_overlapping_bodies):  #required for all towers

	$Sprite.connections = overlap_areas
	$Connector.clear_points()
	#Temporary until we implement working line drawing 
	#======================================================
	
	
	
	#======================================================
	
	hovering = false
	if(re_animate):
	#this function is so when we press the button to place a tower and we just want to show the tower being placed
	#we won't activate this function so it will not activate the tower, only show it
		animated_node.placed = true
	

	animated_node.play("place")
	
	animated_node.animation_finished.connect(Callable(set_clickable))
	
	

#Draw power node lines to direct power through
func get_segments():
	$Connector.clear_points()
	for node in overlap_areas:
		if is_instance_valid(node) and node is sprite_collider and node.get_parent().hovering == false:
			connection_points.append(self.global_position)
			connection_points.append(node.global_position)
		#	$Connector.add_point(to_local(self.global_position))
			#$Connector.add_point(to_local(node.global_position))	

func add_local_point(point):
	if point not in $Connector.points:
		#Only draw line if line not already drawn
		$Connector.add_point(to_local(point))

#still need to fix line drawing, can be done another time

func set_clickable():
	clickable = true
	overlap_areas = $Collision_Area.get_overlapping_areas()

	get_segments()
	
	set_group($Collision_Area.get_overlapping_areas())
	Globals.connect_group_lines()

#Set group according to group of first colliding node

func set_group(overlaps):
	var found_valid = false
	if(len(overlaps)):
		for node in overlaps:
			if(node is sprite_collider):
				if (node.my_group_name != 'NAN'):
					self.add_to_group(node.my_group_name)
					$Sprite.my_group_name = node.my_group_name
					Globals.power_groups[$Sprite.my_group_name][1]+= power_capacity
					Globals.power_groups[$Sprite.my_group_name][3]+= connection_points
					group_ = node.my_group_name
					found_valid = true
					break
					
	if not found_valid:
		var connector_line = Globals.power_lines.instantiate()

		$Sprite.my_group_name = str(Globals.power_groups.size() + 1)
		group_ = $Sprite.my_group_name
		#if tower does not have any towers near by create a new group and a new group line to connect the nodes in this group together
		self.get_parent().add_child(connector_line)

		Globals.power_groups[$Sprite.my_group_name] = [0, power_capacity, connector_line, connection_points]
		 #Will change based on power specifications
		self.add_to_group($Sprite.my_group_name)
	



func set_frame_child(frame): #required for all towers
	animated_node.frame = frame
	
func frame_count(): #required for all towers
	return animated_node.sprite_frames.get_frame_count("place")

func colliding_areas():
	var real_overlaps = []
	for node in sprite_node.get_overlapping_areas():
		if node is sprite_collider:
			real_overlaps.append(node)
	return len(real_overlaps) + len(sprite_node.get_overlapping_bodies()) #all overlapping objects

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
	#Use BFS to find closest solar station 
	var output = iterativeBFS($Sprite)
	return output

	
	
func iterativeBFS(v):
	var discovered = []
	# create a stack used to do iterative DFS
	var queue = []
 
	# push the source node into the stack
	queue.append(v)
 
	# loop till stack is empty
	while len(queue) > 0:
		# Pop a vertex from the stack
		var s = queue[0] 
		queue.pop_front()
 		
		if (s not in discovered): 
			discovered.append(s.get_parent())
		# if the vertex is already discovered yet, ignore it
		
		var test_statment: bool = (s.my_name != 'solar' and s.built and s.correct_area)
		

		for node in s.connections: 

			if (node.get_parent() not in discovered and is_instance_valid(node) and node.correct_area and not node.hovering): 
				node.get_colliding()

				if(node.my_name == 'solar'):
					closest_solar_station = node
					queue =[]
					break
					
				queue.append(node) 
						#---------------------------------------------------------
	return discovered

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
 		
		if (s.get_parent() not in discovered): 
			discovered.append(s.get_parent())
		# if the vertex is already discovered yet, ignore it
	
			
		for node in s.connections: 
			if (is_instance_valid(node) and node.correct_area and not node.hovering and node.get_parent() not in discovered):
					#if(node.my_name == 'solar'):
						#closest_solar_station = node
						#queue =[]
						#break
				node.get_parent().animated_node.frame = 5
				stack.push_front(node) 
						#---------------------------------------------------------
	return discovered

 
