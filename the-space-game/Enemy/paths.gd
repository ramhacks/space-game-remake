extends Node2D


signal curve_points(points)

func _on_surround_add_path(path_node: Variant) -> void:
	#first make a new curve2d with global pos of path_ndoes
	var points = path_node.curve.get_baked_points()
	var output: Array
	var idx = 0
	for p in points:
		var node_global = path_node.global_point(p)
		output.append([self.global_position.distance_to(node_global), idx])
		idx+=1


	curve_points.emit(output)
