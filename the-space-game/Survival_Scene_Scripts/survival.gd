extends Node2D

#list of towers
var mining_tower
var solar_tower


var initial_tower_prices = {
	"miner": 45, #same as cur_name variable
	"solar": 200,
	"Power_Node": 20
}

var tower_scene_dict = {
	"miner": 0,
	"solar": 0,
	"Power_Node": 0
	
}

signal finished_cooldown

signal connect_game_ticks(node)

signal finished

#these two variables are if we are going to place a tower, press the tower button and show the tower following
#the mouse and then what type of tower we are placing, the functionality of the towers will be the same for 
#most towers but has a few exceptions we will implement at a later point
var tower_to_place
var tower_scene

var game_tick_timer
var selection_node

var starting_tower_pos
var activate_nearby_node_showing = false

var waiting_for_clickout = false


var vbox_children = []#list of children in buttons (upgrade level so on) so if they are removed we can add them back in

func clear_hover_lines():
	var hover_line_node
	#fix so that you can't place tower in hotbar
	if(len(get_tree().get_nodes_in_group("hover_line"))):
		hover_line_node = get_tree().get_nodes_in_group("hover_line")[0]
	
	if(hover_line_node):
		hover_line_node.queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var asteroid_scene = preload("res://Asteroid_Gen/asteroid_field.tscn")
	selection_node = preload("res://Selection_Draw_Node/Selection_Draw.tscn").instantiate()
	var tween = self.get_tree().create_tween() #rotate the drawing 
	tween.tween_property(selection_node, "rotation", deg_to_rad(0), 0.5)
	var instance = asteroid_scene.instantiate()
	self.add_child(instance)
	#temporary just to test miner tower
	
	tower_scene_dict['miner'] = preload("res://towers/Miner/miner.tscn")
	
	tower_scene_dict['solar'] = preload("res://towers/Solar/solar.tscn")
	
	tower_scene_dict["Power_Node"] = preload("res://towers/Power_Node/Power_Node.tscn")
	
	game_tick_timer = get_node("Global_Ticks")
	
	self.get_node("Camera_Area").draw_select.connect(draw_selector)
	
	vbox_children.append(self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Selection/Side_Buttons/Custom"))
	vbox_children.append(self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Selection/Side_Buttons/Upgrade_Button"))
	vbox_children.append(self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Selection/Side_Buttons/Recycle"))
	
	var vbox = self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Selection/Side_Buttons")
	var children = Globals.get_all_children(vbox)
	children.pop_front()
	for i in range(1, 3):
		vbox.remove_child(children[i])
	
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(Globals.tower_hovering):
		tower_to_place.position = self.get_node("Camera_Area").get_relative_mouse_pos(false)
		
		#the code below makes it so that we don't try and draw collidiing asteroids until the mouse is not
		#inside the hotbar anymore
		if(starting_tower_pos.y - self.get_node("Camera_Area").get_relative_mouse_pos(false).y > 25):
			tower_to_place.hovering = true
		

func _on_camera_area_cancel_spawn_tower() -> void:
	#if mouse right_clicked and currently placeing_tower cancel it
	if(Globals.tower_hovering):
		clear_hover_lines()
		tower_to_place.queue_free()
		Globals.tower_hovering = false

func _on_camera_area_place_tower(cur_position: Variant) -> void:
	if(Globals.tower_hovering):
		var is_miner_and_overlapping = (tower_to_place.cur_name == "miner" 
										and len(tower_to_place.get_overlap()) != 0)

		if(tower_to_place.cur_name != "miner"):
			is_miner_and_overlapping = true
			
		var above_hot_bar_AND_not_on_tower = ((starting_tower_pos.y - self.get_node("Camera_Area").get_relative_mouse_pos(false).y > 30))	
		
		if(is_miner_and_overlapping and above_hot_bar_AND_not_on_tower):
			if(tower_to_place.colliding_areas() == 0):
				Globals.tower_node_amount += 1
				clear_hover_lines()
				
				assert(initial_tower_prices[tower_to_place.cur_name], "You never added your tower name and price to the initial_tower_prices dictionary
																		Located at line 8 in this file")
																		
				Globals.resources = Globals.resources - initial_tower_prices[tower_to_place.cur_name]
				

				Globals.tower_hovering = false
				var copy = tower_scene.instantiate()
				copy.position = cur_position
				self.add_child(copy)
				
				tower_to_place.queue_free()

				copy.overlap_areas = tower_to_place.get_areas_overlap()
				if tower_to_place.cur_name != 'miner':
					copy.set_placed(true, tower_to_place.get_areas_overlap())
				else:
					copy.set_placed(true, tower_to_place.get_overlap())
				
					
				copy.get_node("collider").visible = false	
				
				#connect tower signals global functions
				copy.draw_laser.connect(draw_laser)
				copy.draw_selection_animation.connect(draw_selector)
				copy.request_power.connect(Globals.power_requested)

					
				#Node has been added, call all tower nodes to reformat lines if needed (if they have a new connection available
				#get_tree().call_group("tower_node", "reformat_lines")
	
				


		
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
	
		

	
	
func hover_line(pos1, pos2_list, R, G, B, opacity, line_node):
	line_node.add_to_group("hover_line")
	line_node.clear_points()
	var color = Color(R, G, B, opacity)
	self.add_child(line_node)
	line_node.set_default_color(color)
	line_node.width = 1.5
	var draw = true
	for nodes in pos2_list:
		#only draw line (only applies to miner class) if asteroid is not empty of resources
		if(nodes.cur_name == "asteroid"):
			if(nodes.asteroid_empty):
				draw = false
			else:
				draw = true
		
			#only draw line (only applies to miner class) if asteroid is not empty of resources	
		if draw:
			line_node.add_point(to_local(pos1))
			line_node.add_point(to_local(nodes.global_position))
			line_node.add_point(to_local(pos1))


#Function to draw selector when tower is clicked and show hotbar
func draw_selector(tower_pos, tower_radius, clicked_self, tower): #if add, add else play tween then remove
	#draw the selection animation, we will add a tween after finishing creating the base selection shape
	
	if(!Globals.tower_hovering):
		if(clicked_self and selection_node not in get_tree().get_nodes_in_group("selection")): #only draw if clicked node
			Globals.tower_selected = tower
			#it has been clicked so now if somewhere that is not this node is clicked hide the select drawing
			Globals.tower_selection_mode = true
			self.add_child(selection_node)
			selection_node.add_to_group("selection")
			selection_node.position = tower_pos
			selection_node.redraw_self(tower_radius)
			#create tween to animate
			var tween = self.get_tree().create_tween() #rotate the drawing 
			tween.tween_property(selection_node, "rotation", deg_to_rad(-90), 0.2)	
			tween.finished.connect(tween_done.bind(true))
			
			show_selection_ui(tower)

			
			
		elif(waiting_for_clickout and selection_node in get_tree().get_nodes_in_group("selection")):
			waiting_for_clickout = false
			selection_node.remove_from_group("selection")
			self.remove_child(selection_node)
			
			hide_selection_ui(Globals.tower_selected)
			
			Globals.tower_selection_mode = false
		
		
func tween_done(create):
	if create:
		waiting_for_clickout = true


#return tower ui node
func get_tower_ui_node(tower_type):
	#you need to name the nodes the same as the cur_name attribute of your tower so we can get the path of their seleciton ui
	
	var pathstring_button = "HotBar_Layer/Hotbar_Background/Hotbar_Forground/Default_Hot Bar/" + tower_type

	return self.get_node(pathstring_button)



#show selection ui	
func show_selection_ui(tower):
	print(tower.group_)
	#re-add all button nodes just in case they were removed in another tower seleciton menu
	var vbox = self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Selection/Side_Buttons")
		
	var children = Globals.get_all_children(vbox)
	children.pop_front()
	for i in children:
		vbox.remove_child(i)
		
	#V[0] is the custom button, we only need to add it if this tower has a custom button option
	if(tower.cur_name == 'miner' or tower.cur_name == 'laser'):
		vbox.add_child(vbox_children[0])
	
	
	vbox.add_child(vbox_children[1])
	self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Selection").check_upgrade_available(tower.upgrade_price[tower.level])
	vbox_children[2].text = "Recycle: " + str(tower.recycle_price[tower.level]) 
	vbox.add_child(vbox_children[2])
	

	self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Default_Hot Bar").visible = false
	
	self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Selection").show_selection_nodes(tower)

	assert(tower.cur_name != "tower name", "You didn't name the tower cur_name! We can't find the associated ui elements for this tower")
	
	var ui_list = get_tower_ui_node(tower.cur_name)



#hide selection and go back to default hotbar



func hide_selection_ui(tower):
	self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Default_Hot Bar").visible = true
	
	var ui_list = get_tower_ui_node(tower.cur_name)


	
	var tween = self.get_tree().create_tween() #rotate the drawing 
	tween.tween_property(selection_node, "rotation", deg_to_rad(0), 0)	
	tween.finished.connect(hide_tween_done)
	
func hide_tween_done():
	#if we need to remove this node say that yes we can
	finished.emit()
	
	
#recycle tower function
func _on_side_buttons_hide_selection() -> void:
	Globals.tower_selection_mode = false
	Globals.tower_node_amount -= 1
	waiting_for_clickout = false
	selection_node.remove_from_group("selection")
	self.remove_child(selection_node)
	Globals.tower_selected.remove_from_group(Globals.tower_selected.group_)
	Globals.tower_selected.sprite_var_node_holder.correct_area = false

	Globals.connect_group_lines(Globals.tower_selected)
	Globals.tower_selected.queue_free()
	

	
	hide_selection_ui(Globals.tower_selected)
	Globals.tower_selection_mode = false
	
	




func tower_button_clicked(price, tower_type):
	if(Globals.resources - price >= 0 and !Globals.tower_hovering):
		tower_scene = tower_type
		tower_to_place = tower_scene.instantiate() #create a temporary tower object, will be deleted and replaced once placed
		
		tower_to_place.draw_hover_line.connect(hover_line)
		tower_to_place.hovering = true
		#don't run the placed function so nothing will happen
		self.add_child(tower_to_place)
		starting_tower_pos = self.get_node("Camera_Area").get_relative_mouse_pos(false)
		tower_to_place.set_frame_child(tower_to_place.frame_count())
		Globals.tower_hovering = true
		


#connect button nodes to corresponding button_press_signals
func _on_default_hot_bar_nodes_to_connect(button_nodes: Variant) -> void:
	for buttons in button_nodes:
		if buttons is Tower_Button:
			buttons.But_pressed.connect(tower_button_pressed)

func tower_button_pressed(button_target) -> void:
	#helper func for tower_button_clicked
	tower_button_clicked(initial_tower_prices[button_target], tower_scene_dict[button_target])

	
