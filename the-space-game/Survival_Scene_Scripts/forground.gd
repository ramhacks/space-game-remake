extends Panel

@export var update_delay = 10 #Frames
var current_frame = 0



# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Count frames, when it has been more than update_delay frames since the last update, update the location of all 
	#radar nodes
	if current_frame == update_delay:
		get_tree().call_group("Radar_Markers", "move_radar_marker")
		current_frame = 0
	current_frame += 1
	

func _on_survival_create_radar_node(node: Variant) -> void:
	self.add_child(node)


func _on_survival_remove_radar_node(node: Variant) -> void:
	pass # Replace with function body.
