extends Sprite2D

#draw a simple triangle enemy
var coords_triangle = [
	[ 0, 4 ], [ 8, 8 ],
	[ 8, 0 ], [0, 4]
]

var tri : PackedVector2Array

func float_array_to_Vector2Array(coords : Array) -> PackedVector2Array:
	# Convert the array of floats into a PackedVector2Array.
	var array : PackedVector2Array = []
	for coord in coords:
		array.append(Vector2(coord[0], coord[1]))
	return array
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tri = float_array_to_Vector2Array(coords_triangle);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	var godot_blue : Color = Color("ed1616")
	# We pass the PackedVector2Array to draw the shape.
	draw_polygon(tri, [ godot_blue ])
