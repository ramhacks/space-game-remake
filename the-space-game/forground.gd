extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_survival_create_radar_node(node: Variant) -> void:
	self.add_child(node)


func _on_survival_remove_radar_node(node: Variant) -> void:
	pass # Replace with function body.
