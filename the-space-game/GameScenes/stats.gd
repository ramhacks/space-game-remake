extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "You lasted until wave " + str(Globals.wave_number)
	Globals.reset_all()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
