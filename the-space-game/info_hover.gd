extends Control

var descript_file = "res://Descriptions/descriptions.json"
var info_text_dict

var button_nodes_list

var point_xpos_dict = { #dictionary to tell where to move the pointer triangle 
						#according to which tower info button is being hovered over
	"Power_Node": 0,
	"miner": 108,
	"solar": 216
}

func _ready() -> void:
	var json_as_text = FileAccess.get_file_as_string(descript_file)
	info_text_dict = JSON.parse_string(json_as_text)
	
func _on_default_hot_bar_nodes_to_connect(button_nodes: Variant) -> void:
	button_nodes_list = button_nodes
	for buttons in button_nodes_list:
		if buttons is Tower_Button:
			
			buttons.Info_Hovering.connect(hover_on)
			buttons.Info_Hover_off.connect(hover_off)

#display the info text and also move the pointer to the corresponding tower that has the info button the mouse is hovering over
func hover_on(type) -> void:
	if not Globals.tower_selection_mode:
		#untoggle all buttons except currently pressed button
		for buttons in button_nodes_list:
			if buttons is Tower_Button and buttons.tower_button_target != type:
				buttons.set_button_pressed(false, false)
				
				
		self.show()
		$Pointer.position.x = point_xpos_dict[type]
		$Info_Text.text = info_text_dict[type]
		
#hide because mouse has left the info button
func hover_off() -> void:
	self.hide()

#called when mouse clicked outside of hot bar, assuming player is done looking at the info can change if becomes an issue
func _on_camera_area_hide_info_boxes() -> void:
	for buttons in button_nodes_list:
		if buttons is Tower_Button:
			buttons.set_button_pressed(false, true)
