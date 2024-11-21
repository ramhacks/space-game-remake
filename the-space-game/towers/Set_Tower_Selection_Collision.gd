extends Area2D

class_name sprite_collider



#copy of parent variables so that when traversing the graph we can access properties of parent
var correct_area = true
var connections = []


# Called when the node enters the scene tree for the first time.

func set_size(obj) -> void:
	var radius = self.get_parent().animated_node.get_sprite_frames().get_frame_texture('hover', 0).get_size().x/2
	obj.shape.set_radius(radius)
	self.add_child(obj)
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
