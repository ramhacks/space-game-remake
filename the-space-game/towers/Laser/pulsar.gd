extends State

var custom_class

var pulsar_damage_map = {
	2: 50,
	3: 80
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func do_process(parent_node):
	print("Pulsar now")
