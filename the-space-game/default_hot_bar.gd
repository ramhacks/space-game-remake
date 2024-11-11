extends Control

signal nodes_to_connect(button_nodes)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mychildren = Globals.get_all_children(self)
	nodes_to_connect.emit(mychildren)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
