extends Node2D

#AI GENERATED wanted just a quick way to draw a circle so had ai do it
@export var circle_color: Color = Color(1.0, 0.0, 0.0, 0.4) # Transparent Red

@export var radius: float = 60.0:
	set(value):
		radius = value
		queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, circle_color)
