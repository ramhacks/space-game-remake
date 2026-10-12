extends Button

var upgrade_name = ""

signal Upgrade_Pressed(label)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# When pressed emit it was pressed so that parent can handle actually upgrading the tower selected
func _on_pressed() -> void:
	Upgrade_Pressed.emit(upgrade_name)
