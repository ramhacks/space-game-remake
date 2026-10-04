extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Source: targeting.gd
## Purpose: Change Sprite
func _on_targeting_changetarget(newtarget: String) -> void:
	if self.sprite_frames.has_animation(newtarget):
		play(newtarget)
