extends Control

class_name Tower_Button 

@export var tower_button_target: String
@export var Normal_Texture: Texture2D
@export var Pressed_Texture: Texture2D
@export var Display_Price: String
@export var Shortcut_Key: String

signal But_pressed(type)
signal Info_Hovering(type)
signal Info_Hover_off

var shortcut_event: InputEventKey

func to_ascii(input_string: String) -> int:
	var output: int
	assert(len(input_string) == 1, "Can only set shortcut keybinds to lettered/numbered keys")
	output = input_string.unicode_at(0)
	if(output >= 97):
		input_string = input_string.to_upper()
		output = input_string.unicode_at(0)
	return output
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shortcut_event = InputEventKey.new()
	$select_button.texture_normal = Normal_Texture
	$select_button.texture_pressed = Pressed_Texture
	$Price.text = Display_Price + 'm'

	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_select_button_pressed() -> void:
	But_pressed.emit(tower_button_target)

func set_disabled() -> void:
	$select_button.disabled = true
	
func set_enabled() -> void:
	$select_button.disabled = false


func set_button_pressed(set_val: bool, signal_option: bool) -> void:
	if not signal_option:
		$Info.set_pressed_no_signal(set_val)
	else:
		$Info.set_pressed(set_val)

func _on_info_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Info_Hovering.emit(tower_button_target)
	else:
		Info_Hover_off.emit()


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == to_ascii(Shortcut_Key):
			But_pressed.emit(tower_button_target)
