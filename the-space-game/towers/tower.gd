extends Node2D

class_name Tower



# Add an item to the queue if it has not reached its maximum capacity
func add_to_queue(queue, item):
	if len(queue):
		queue.push_back(item)

# Removes the front item from the queue and returns whether or not the queue was empty
func finish_queue_front(queue):
	if(len(queue)):
		return queue.pop_front()
	else:
		return -1
	

var child_area
var sprite_node
var animated_node
var inherted_node #for methods that require the inhereted node
var level = 1

#ENERGY VARS
var connections = []
var sent_nodes = []
var sent_ = false
var powered = false 




var finished_traversing = false
var finished_traverse_off = false
var player_ = false #used to check if enemy should attack it or not
var show_colliding_bodies = false

@export var health = 300

var build_progress = 0 #percantage up to 100

var built = true #we will set this to false when we implement power

var hover_line = Line2D.new()  #hover line node pointer

signal draw_laser(tower, pos1, pos2, cooldown_time, tower_origin)

signal draw_hover_line(pos1, pos2_list, R, G, B, opacity, line_node)
signal draw_selection_animation(tower_pos, tower_radius, clicked_self, tower_type)

signal draw_power_line(tower, pos1, pos2)

@export var cur_name = "tower name" #used if we want to identify the type of tower, 

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
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite.my_name = cur_name
	$Sprite.connections = $Collision_Area.get_overlapping_areas()
	animated_node.upgrade_level = level
	
	if(len(sprite_node.get_overlapping_areas()) > 0):
		
		on_object = true
	else:
		on_object = false
		
	if hovering:
		send_hover_line()
	if build_progress == 100 and !built:
		self.get_node("BuildProgress").set_visible(false)
		built = true
	else:
		self.get_node("BuildProgress").value = build_progress
	
func send_hover_line():
	if(show_colliding_bodies):
		if(len(sprite_node.get_overlapping_bodies()) > 0):
			on_object = true
		else:
			on_object = false
				
		var overlap = child_area.get_overlapping_bodies()
		draw_hover_line.emit(self.global_position, overlap, 0.192, 0.988, 0.165, 3, hover_line)
	
	
func set_placed(re_animate, current_overlapping_bodies):  #required for all towers
	hovering = false
	if(re_animate):
		animated_node.frame = 0
	#this function is so when we press the button to place a tower and we just want to show the tower being placed
	#we won't activate this function so it will not activate the tower, only show it
		animated_node.placed = true
		
	animated_node.play("place")
	
	var clickable_ = Timer.new() # wait 0.5 seconds until clicking, ensures tower has not just been placed (when placed it would think
	#it has been clicked
	self.add_child(clickable_)
	clickable_.set_wait_time(0.5)
	clickable_.timeout.connect(Callable(set_clickable).bind(clickable_))
	clickable_.start()
	
func set_clickable(clickable_):
	clickable = true
	clickable_.queue_free()

func set_frame_child(frame): #required for all towers
	animated_node.frame = frame
	
func frame_count(): #required for all towers
	return animated_node.sprite_frames.get_frame_count("place")

func colliding_areas():
	return len(sprite_node.get_overlapping_areas()) + len(sprite_node.get_overlapping_bodies()) #all overlapping objects

#get overlapping bodies and areas, used here to neaten above survival code	
func get_overlap():
#overlapping bodies (for asteroid detection)		#overlapping areas to make sure we are not on top of another node
	return child_area.get_overlapping_bodies()
	
func get_areas_overlap():
	return child_area.get_overlapping_areas()
	
func _on_sprite_2d_draw_line(pos1: Variant, pos2: Variant) -> void:
	cooling_down = true

	draw_laser.emit(self, pos1, pos2, cooldown_delay, self) 
	#we can't use tweens because tweens are meant for single animations
	#we need to animate 2 things at once so we have to use attached line node and can't dynamically create one


#upgrade tower (max of 3)
func upgrade():
	pass
	
func rebuild():
	build_progress = 0
	built = false
	self.get_node("BuildProgress").set_visible(true)
	self.get_node("BuildProgress").value = 0 #reset value


func place_build_progress_bar(): 
	var build_bar = self.get_node("BuildProgress")
	build_bar.position.y = build_bar.position.y - (sprite_texture.get_size().y/2) - 2
	
func _on_sprite_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and clickable:
		if event.is_action("BUTTON_LEFT"):
			draw_selection_animation.emit(self.global_position, sprite_texture.get_size().x/2, true,  inherted_node)
			#will change the hot bar or something to let us upgrade the selected tower





#traverse graph to turn nodes on, traverses every node recursively until it runs out of available energy in which it stops and exits the loop

func traverse_graph_power(start_node, energy_left,  visted=null):
	if visted == null:
		visted = []
	visted.append(start_node)
	for next in start_node.connections:
		if(next not in visted and is_instance_valid(next) and next.correct_area and next.my_name != "solar"):
			if next.my_name != 'Power_Node':
				energy_left -= 50
			if(energy_left > 0):
				next.powered = true
				next.set_val()
				traverse_graph_power(next, energy_left, visted)
	
	self.finished_traversing = true
	return visted

#traverse graph to turn nodes off
func traverse_graph_off(start_node, visted=null):
	if visted == null:
		visted = []
	visted.append(start_node)
	for next in start_node.connections:
		if(next not in visted and is_instance_valid(next) and next.correct_area):
			next.powered = false
			next.reset_power()
			traverse_graph_off(next, visted)
			
	
	self.finished_traverse_off = true
	return visted

#power off
func _on_sprite_reset_powers() -> void:
	self.powered = false
	animated_node.play("no_power")

#power on
func _on_sprite_set_powered_val() -> void:
	inherted_node.do_process()
	self.powered = true
	animated_node.play("powered")
