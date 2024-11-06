extends AnimatedSprite2D

var upgrade_level = 1  #same as parent value, miner just needs it so it knows how much it needs to mine

signal draw_line(pos1, pos2)


var upgrade_map = {
	1: 10,
	2: 20
}

var closest = false
var valid = false

var placed = false #required for all towers

var current_drained

signal force_change_collision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
