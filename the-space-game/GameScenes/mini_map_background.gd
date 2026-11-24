extends Panel

var defaulthex := Color("616161d7")
var highlighted := Color("fffc00")


var style: StyleBoxFlat
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	style = get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	add_theme_stylebox_override("panel", style)
	style.bg_color = defaulthex


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Highlight minimap
func _on_hot_bar_layer_highlight_minimap() -> void:
	style.bg_color = highlighted


func _on_hot_bar_layer_de_highlight_minimap() -> void:
	style.bg_color = defaulthex
