var zoom_factor = 1.1
var min_zoom = 0.5
var max_zoom = 3.0

func zoom_at(mouse_pos: Vector2, factor: float) -> void:
	var old_zoom = cam.zoom.x
	var new_zoom = clamp(old_zoom * factor, min_zoom, max_zoom)
	if is_equal_approx(old_zoom, new_zoom):
		return

	# world point currently under the cursor
	var world_before = position + mouse_pos / old_zoom
	cam.zoom = Vector2(new_zoom, new_zoom)
	# shift the camera so that same point stays under the cursor
	position = world_before - mouse_pos / new_zoom

	# keep an in-progress drag from jumping
	if dragging:
		mouse_start_pos = get_viewport().get_mouse_position()
		screen_start_position = position
