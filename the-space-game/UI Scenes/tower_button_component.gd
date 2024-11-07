extends Control

class_name Tower_Button 

@export var tower_button_target: String
@export var Normal_Texture: Texture2D
@export var Pressed_Texture: Texture2D
@export var Display_Price: String

signal But_pressed(type)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$select_button.texture_normal = Normal_Texture
	$select_button.texture_pressed = Pressed_Texture
	$Price.text = Display_Price + 'm'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_select_button_pressed() -> void:
	But_pressed.emit(tower_button_target)
