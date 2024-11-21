extends Control
#Edits screen text to display current minerals and current energy the player has

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Resources.text = str(Globals.resources) + " minerals"
	$Energy.text = str(Globals.total_current) + " energy"
