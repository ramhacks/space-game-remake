extends AnimatedSprite2D

#required variables
#---------------------------
var upgrade_level = 1  #same as parent value, miner just needs it so it knows how much it needs to mine


var closest = false
var valid = false

var placed = false #required for all towers

#---------------------------

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
