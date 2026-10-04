extends Node2D

#list of towers
var mining_tower
var solar_tower

# Prices of All Towers, Should not be located here
var tower_price_dict = {
	"Miner": 45,
	"Solar": 200,
	"Relay": 20,
	"Repair_Station": 300,
	"Battery":300,
	"Laser":100,
	"Missile_Launcher":400

}

var tower_scene_dict = {
	"Miner": 0,
	"Solar": 0,
	"Relay": 0,
	"Repair_Station": 0,
	"Battery":0,
	"Laser":0,
	"Missile_Launcher":0

}

signal finished_cooldown

signal connect_game_ticks(node)

signal finished
signal create_radar_node(node)
signal remove_radar_node(node)

signal rebake_mesh(node_added)
#these two variables are if we are going to place a tower, press the tower button and show the tower following
#the mouse and then what type of tower we are placing, the functionality of the towers will be the same for
#most towers but has a few exceptions we will implement at a later point
var tower_to_place
var tower_scene

var radar_node
var radar_level

var game_tick_timer


var starting_tower_pos
var activate_nearby_node_showing = false

var waiting_for_clickout = false


var button_themes = {
	"Custom_Button": 0,
	"Upgrade_Button": 0
}



var enemy_node




var enemy
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
	Globals.main_scene = self
	process_mode = Node.PROCESS_MODE_ALWAYS

	#REMEBER TO ADD YOU TOWER TO THE LOAD ORDER

	radar_node = preload("res://Visuals/Minimap_textures/radar_marker.tscn")

	tower_scene_dict['Miner'] = preload("res://towers/Miner/miner.tscn")

	tower_scene_dict['Solar'] = preload("res://towers/Solar/solar.tscn")

	tower_scene_dict['Repair_Station'] = preload("res://towers/Repair_Station/Repair_Station.tscn")

	tower_scene_dict["Relay"] = preload("res://towers/Power_Node/Power_Node.tscn")

	tower_scene_dict["Battery"] = preload("res://towers/Battery/battery.tscn")

	tower_scene_dict["Laser"] = preload("res://towers/Laser/Laser.tscn")

	tower_scene_dict["Missile_Launcher"] = preload("res://towers/Missle_Launcher/Missile_Launcher.tscn")

	#Put Missile Launcher Here

	button_themes["Custom_Button"] = preload("res://Visuals/Themes/Custom_Button.tres")

	button_themes["Upgrade_Button"] = preload("res://Visuals/Themes/Upgrade_Button.tres")

	var asteroid_scene = preload("res://Asteroid_Gen/asteroid_field.tscn")

	Globals.selection_node = preload("res://Selection_Draw_Node/Selection_Draw.tscn").instantiate()

	enemy = preload("res://Enemy/Enemy_Types/Power_Targeter.tscn")

	radar_level = get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/MiniMapBackground/Forground/Minimap")
	var tween = self.get_tree().create_tween() #rotate the drawing
	tween.tween_property(Globals.selection_node, "rotation", deg_to_rad(0), 0.5)
	var instance = asteroid_scene.instantiate()
	self.add_child(instance)





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

	enemy_node = enemy.instantiate()




	#Add solar node to center:
	tower_to_place = tower_scene_dict['Solar'].instantiate() #create a temporary tower object, will be deleted and replaced once placed


		#don't run the placed function so nothing will happen
	self.add_child(tower_to_place)

	tower_to_place.global_position = Vector2(1152/2, 648/2)
	place_first_solar_node()





func place_first_solar_node():

	var copy = tower_scene_dict['Solar'].instantiate()
	copy.position = Vector2(1152/2, 648/2)
	self.add_child(copy)

	tower_to_place.queue_free()

	copy.overlap_areas = tower_to_place.get_areas_overlap()
	if tower_to_place is Miner:
		copy.set_placed(true, tower_to_place.get_areas_overlap())
	else:
		copy.set_placed(true, tower_to_place.get_overlap())


	copy.get_node("collider").visible = false

	#connect tower signals global functions
	copy.draw_laser.connect(draw_laser)
	copy.draw_selection_animation.connect(draw_selector)
	copy.request_power.connect(Globals.power_requested)


	var marker_instance = radar_node.instantiate()

	copy.radar_marker = marker_instance
	copy.update_location.connect(marker_instance.on_update_location)
	create_radar_node.emit(marker_instance)

	marker_instance.get_relative.connect($Camera_Area.call_rel)
	$Camera_Area.send_rel.connect(marker_instance.receive_relative)

	Globals.no_power_available.connect(copy.no_power_available)

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
		var is_miner_and_overlapping = (tower_to_place is Miner
										and len(tower_to_place.get_overlap()) != 0)

		if((!tower_to_place is Miner)):
			is_miner_and_overlapping = true

		var above_hot_bar_AND_not_on_tower = ((starting_tower_pos.y - self.get_node("Camera_Area").get_relative_mouse_pos(false).y > 30))

		if(is_miner_and_overlapping and above_hot_bar_AND_not_on_tower):
			if(tower_to_place.colliding_areas() == 0):
				Globals.tower_node_amount += 1
				clear_hover_lines()

				Globals.resources = Globals.resources - tower_to_place.current_upgrade_node.price


				Globals.tower_hovering = false
				var copy = tower_scene.instantiate()
				copy.position = cur_position
				self.add_child(copy)

				tower_to_place.queue_free()

				copy.overlap_areas = tower_to_place.get_areas_overlap()
				if tower_to_place is Miner:
					copy.set_placed(true, tower_to_place.get_areas_overlap())
				else:
					copy.set_placed(true, tower_to_place.get_overlap())


				copy.get_node("collider").visible = false

				#connect tower signals global functions
				copy.draw_laser.connect(draw_laser)
				copy.draw_selection_animation.connect(draw_selector)
				copy.request_power.connect(Globals.power_requested)


				var marker_instance = radar_node.instantiate()

				copy.radar_marker = marker_instance
				copy.update_location.connect(marker_instance.on_update_location)
				create_radar_node.emit(marker_instance)

				marker_instance.get_relative.connect($Camera_Area.call_rel)
				$Camera_Area.send_rel.connect(marker_instance.receive_relative)

				Globals.no_power_available.connect(copy.no_power_available)










func draw_laser(tower, pos1, pos2, cooldown_time, tower_origin):
	#create line node
	# 3 points,
	#1st is self(pos1) position
	#2nd is pos2 position
	#3rd is self(pos1) position again
	var line = tower.get_node("Laser")

	line.clear_points()
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
		if(nodes is Asteroid):
			if(nodes.asteroid_empty):
				draw = false
			else:
				draw = true

			#only draw line (only applies to miner class) if asteroid is not empty of resources
		if draw and nodes is Asteroid:
			line_node.add_point(to_local(pos1))
			line_node.add_point(to_local(nodes.global_position))
			line_node.add_point(to_local(pos1))


#Function to draw selector when tower is clicked and show hotbar
func draw_selector(tower_pos, tower_radius, clicked_self, tower): #if add, add else play tween then remove
	#draw the selection animation, we will add a tween after finishing creating the base selection shape

	if(!Globals.tower_hovering):
		if(clicked_self and Globals.selection_node not in get_tree().get_nodes_in_group("selection")): #only draw if clicked node
			Globals.tower_selected = tower
			#it has been clicked so now if somewhere that is not this node is clicked hide the select drawing
			Globals.tower_selection_mode = true
			self.add_child(Globals.selection_node)
			Globals.selection_node.add_to_group("selection")
			Globals.selection_node.position = tower_pos
			Globals.selection_node.redraw_self(tower_radius, tower.get_node("Sprite_Node/Sprite2D").scale.x)
			#create tween to animate
			var tween = self.get_tree().create_tween() #rotate the drawing
			tween.tween_property(Globals.selection_node, "rotation", deg_to_rad(-90), 0.2)
			tween.finished.connect(tween_done.bind(true))

			show_selection_ui(tower)



		elif(waiting_for_clickout and Globals.selection_node in get_tree().get_nodes_in_group("selection")):
			waiting_for_clickout = false
			Globals.selection_node.remove_from_group("selection")
			self.remove_child(Globals.selection_node)

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

	#re-add all button nodes just in case they were removed in another tower seleciton menu
	var vbox = self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Selection/Side_Buttons")



	var children = Globals.get_all_children(vbox)
	children.pop_front()
	for i in children:
		vbox.remove_child(i)

	#Only display upgrade buttons if upgrade is available in the tree (are there children or is it a leaf node)


	if len(tower.current_upgrade_node.children) > 0 and tower.built:
		if len(tower.current_upgrade_node.children) > 1:
			vbox_children[0].theme = button_themes["Custom_Button"]
			vbox_children[0].text = tower.current_upgrade_node.children[1].label + ": " + str(tower.current_upgrade_node.children[1].price)
			vbox.add_child(vbox_children[0])

		vbox_children[1].text = tower.current_upgrade_node.children[0].label + ": " + str(tower.current_upgrade_node.children[0].price)

		vbox.add_child(vbox_children[1])


	vbox_children[2].text = "Recycle: " + str(tower.current_upgrade_node.recycle_price)
	vbox.add_child(vbox_children[2])


	self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Default_Hot Bar").visible = false

	self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Selection").show_selection_nodes(tower)



	var ui_list = get_tower_ui_node(tower.custom_class)



#hide selection and go back to default hotbar



func hide_selection_ui(tower):
	self.get_node("HotBar_Layer/Hotbar_Background/Hotbar_Forground/Default_Hot Bar").visible = true

	var ui_list = get_tower_ui_node(tower.custom_class)



	var tween = self.get_tree().create_tween() #rotate the drawing
	tween.tween_property(Globals.selection_node, "rotation", deg_to_rad(0), 0)
	tween.finished.connect(hide_tween_done)

func hide_tween_done():
	#if we need to remove this node say that yes we can
	finished.emit()


#recycle tower function
func _on_side_buttons_hide_selection() -> void:
	Globals.tower_selected.radar_marker.queue_free()

	Globals.tower_selection_mode = false
	Globals.tower_node_amount -= 1
	waiting_for_clickout = false
	Globals.selection_node.remove_from_group("selection")
	self.remove_child(Globals.selection_node)

	Globals.tower_selected.remove_from_group(Globals.tower_selected.group_)
	Globals.tower_selected.sprite_var_node_holder.correct_area = false

	Globals.remove_node_from_group(Globals.tower_selected)

	Globals.connect_group_lines(Globals.tower_selected)


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
	tower_button_clicked(tower_price_dict[button_target], tower_scene_dict[button_target])


func remove_selection():
	pass
