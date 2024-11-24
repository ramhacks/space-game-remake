extends Area2D

class_name sprite_collider



#copy of parent variables so that when traversing the graph we can access properties of parent
var correct_area = true
var connections = []


# Called when the node enters the scene tree for the first time.

func set_size(obj) -> void:
	self.get_parent().radius = self.get_parent().animated_node.get_sprite_frames().get_frame_texture('hover', 0).get_size().x/2
	obj.shape.set_radius(self.get_parent().radius)
	self.add_child(obj)
	
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy_Missile:

		self.get_parent().health -= area.get_parent().damage
