extends Node2D

class_name Tower


var current_upgrade_node #Node we are currently on in the upgrade tree


#We need to define a custom class because godot does not support grabbing the class_name of a tower
#you can only grab the default class, for instance this would not be tower but would return Node2D instead
@export var custom_class: String

var health_connected = false

#Enemy Collision (For laser enemies):
var sprite_radius = 1

var killed = false
var line_node_connections = []
 #what group this node belongs to

var radar_marker: Radar #node containing pointer to node on minimap representing tower


var no_power_animation_on = false

var child_area
var sprite_node
var animated_node
var inherted_node #for methods that require the inhereted node
var sprite_var_node_holder
var my_collding_radius #so we don't have to call deeper into the node to check this towers collider 

var level = 1

#ENERGY VARS
var connection_points: Array = [] 
#list of connections to other nodes via global position, will be used by each groups line connector to connect
var connected_to_node_freed = false
# each node to eachother
var group_: String = 'NAN'



@export_category("Power")
@export var power_capacity: int = 1

#amount that this tower needs to function
#We can modify this to be customized when implementing missles/lasers
@export var power_needed: int
@export var power_time_seconds: int

var connections: Array = []
var sent_: bool = false

#Self so globals when it recieves the request can trigger the do_process function in the tower
#power needed is the amount of power we are requesting from the group
signal request_power(sender, group, power_needed)

var overlap_areas: Array = []


var show_colliding_bodies: bool = false

var build_progress: int = 0 #percantage up to 100
var built: bool = false #we will set this to false when we implement power
var set_build_frame: bool = false



var hover_line = Line2D.new()  #hover line node pointer



signal draw_laser(tower, pos1, pos2, cooldown_time, tower_origin)
signal draw_hover_line(pos1, pos2_list, R, G, B, opacity, line_node)
signal draw_selection_animation(tower_pos, tower_radius, clicked_self, tower_type)
signal update_location(loc)

var cur_name: String = "tower name" #used if we want to identify the type of tower 

var cooldown_delay: bool = 3  #may need to be adjusted based on upgrade level
var cooling_down: bool = false

var line_node

var hovering: bool = false #hovering next to mouse, not placed yet
#assumed false until told otherwise



var clickable: bool = false #this is so that we don't think the tower is being clicked after we place it down

var on_object: bool = false #if sprite itself is on asteroid don't let the player place the tower

var sprite_texture #used to get radius and height of sprite to draw selection animation and place build_progress_bar



func reset_line():
	connections.erase(-1)
	$Connector.redraw_no_priority(connections)


	

		
#node names are not preserved when instantced in a different scene only for nodes in the same scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	#set child node static variables
	sprite_var_node_holder = $Sprite
	my_collding_radius = $Collision_Area

	place_build_progress_bar()
	$Power_Delay.wait_time = power_time_seconds
	

func place_build_progress_bar(): 
	$BuildProgress.position.y = $BuildProgress.position.y - (sprite_texture.get_size().y/2.5) 

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#set child node and self dynamic variables

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
	
func move_minimap_icon():
	if(not hovering):
		update_location.emit(self.global_position)	
	

	
	

	
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
	
	var loop_array: Array
	if input_array:
		connection_points.append(self.global_position)
		loop_array = input_array
	else:
		loop_array = $Sprite.connections
		
	for node in loop_array:
		if node is sprite_collider and is_instance_valid(node) and node.correct_area:
			$Connector.add_point(to_local(self.global_position))
			$Connector.add_point(to_local(node.global_position))	
			if input_array:
				connection_points.append(node.global_position)
				
	
				
				
#Functions that tend to be overloaded by inherted towers
#-----------------------------------------------------------------

func set_placed(re_animate, current_overlapping_bodies):  #required for all towers

	$Sprite.connections = overlap_areas
	$Connector.clear_points()

	hovering = false

	

	animated_node.play(current_upgrade_node.label)
	
	
	animated_node.animation_finished.connect(Callable(set_clickable))
	
	

#Draw power node lines to direct power through
func get_segments():
	$Connector.clear_points()
	
	$Connector.priority_lines(connections)

func add_local_point(point):
	$Connector.add_point(to_local(point))

#POWER FUNCTIONS AND FUNCITONALITY
#=====================================================================================
func set_clickable():
	clickable = true
	connections = $Collision_Area.get_overlapping_areas()
	get_segments()
	set_group($Collision_Area.get_overlapping_areas())
	if(power_time_seconds > 0):
		
		$Power_Delay.start() #Start power_timer cycle
		
	self.add_to_group("Placed_Towers")
	#put on minimap:
	
func _on_power_delay_timeout() -> void:
	#don't emit if it doesn't need power to work
	if(current_upgrade_node.energy_needs) > 0:
		request_power.emit(self, group_, current_upgrade_node.energy_needs)

#Convert group to any group we want
func convert_group(group_target):
	self.remove_from_group(group_)
	group_ = group_target
	self.add_to_group(group_target)

	
func set_group(overlaps):
	var found_valid: bool = false
	var found_groups = []
	
	if(len(overlaps)):
		for node in overlaps:
			if(node is sprite_collider):
				if (node.get_parent().group_ != 'NAN'):
					found_groups.append(node.get_parent().group_)
					if(not found_valid):
						
						self.add_to_group(node.get_parent().group_)
						
						Globals.power_groups[node.get_parent().group_][1]+= power_capacity
						Globals.total_capacity += power_capacity
						group_ = node.get_parent().group_
						found_valid = true
	
	#2 types of groups, convert all nodes in every other group to myself, delete all other groups except group 
	#I belong to 
	
		
		
	#Can't find any groups, create a new one
	if not found_valid:
		var connector_line = Globals.power_lines.instantiate()
		if(Globals.power_groups.size() - 1 >= 0):
			if(len(get_tree().get_nodes_in_group(str(Globals.power_groups.size() - 1)))) == 0:
				group_ = str(Globals.power_groups.size() - 1)		
			else:
				group_ = str(Globals.power_groups.size() + 1)
		else:
			group_ = str(Globals.power_groups.size() + 1)
		#if tower does not have any towers near by create a new group and a new group line to connect the nodes in this group together
		self.get_parent().add_child(connector_line)

		Globals.power_groups[group_] = [0, power_capacity]
		Globals.total_capacity += power_capacity
		Globals.total_current += 0
		
		 #Will change based on power specifications
		self.add_to_group(group_)

	if(group_ == 'NAN'): #EDGE CASE
		group_ = found_groups[0]
		
	if(len(found_groups) > 1):
		for g in found_groups:
			get_tree().call_group(g, "convert_group", group_)
		Globals.group_changed_adjust_max_power(group_)
	
	$Power_Delay.start()



func no_power_available(sender):
	#only act if we are the ones who's power was not able to be recieved
	if sender == self and built: #only change if tower is built, if it isn't user can just see that the build meter is not going up
			#Play no power_animation
		if inherted_node is Laser:
			animated_node.play(current_upgrade_node.label + " dead")
		else:
			pass
		
		no_power_animation_on = true

	
	
func do_process():
	
	#This if statment is for if there previously was no power available but we got power back
	if no_power_animation_on and built:

		animated_node.animation = current_upgrade_node.label
		
		#After changing the animation to the respective thing (if it is a laser we have to pick the 
		#correct path animation to do, change the frame to the last frame
		#in the animation, this would be the same as the node when it is powered normally)	
		animated_node.frame = animated_node.get_sprite_frames().get_frame_count(animated_node.animation)
	
	if not built and build_progress < 100:
		build_progress += 20

	$Power_Delay.start()
	
#===============================================================================================


func set_frame_child(frame): #required for all towers
	animated_node.frame = frame
	
func frame_count(): #required for all towers
	return animated_node.sprite_frames.get_frame_count("place")

func colliding_areas():
	var real_overlaps: Array = []
	for node in sprite_node.get_overlapping_areas():
		if node is sprite_collider:
			real_overlaps.append(node)
	return len(real_overlaps) + len(sprite_node.get_overlapping_bodies()) #all overlapping objects


	
func get_areas_overlap():
	return child_area.get_overlapping_areas()

func get_sprite_overlap():
	return $Sprite.get_overlapping_areas()
	
func upgrade(upgrade_type):
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
func _on_sprite_2d_draw_line(pos1: Variant, pos2: Variant) -> void:
	cooling_down = true
	draw_laser.emit(self, pos1, pos2, cooldown_delay, self) 
	#we can't use tweens because tweens are meant for single animations
	#we need to animate 2 things at once so we have to use attached line node and can't dynamically create one
	
	
#This tower has no more health, recycle it
