extends Control


var limit = 0
var current = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(current) + "/" + str(limit)

func set_limit(input_limit: int):
	self.limit = input_limit

func set_current(value: int):
	current = value
