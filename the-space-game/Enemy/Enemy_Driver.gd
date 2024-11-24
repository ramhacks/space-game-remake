extends CharacterBody2D


var Targeting: Dictionary = {
	"Random": "Targeting/Random_Target"
}

var target_strat: String


var speed:int = 200
var accel: int = 1

var distance_size: int = 30

var prev_point: Vector2
var direction: Vector2

var first_move: bool = true
var five_frames = 0

@onready var nav: NavigationAgent2D = $NavigationAgent2D

var start_targeting = false
var mis

signal tower_removed

func _ready() -> void:
	mis = preload("res://Enemy/missle.tscn")
	$StateMachine.start_ai()
	
func set_target():
	
	$StateMachine.start_ai()
	
func get_new_target():
	return self.get_node(Targeting[target_strat]).get_target()
	

func _on_surround_send_laser(target: Variant) -> void:
	if five_frames == 10:
		
		var out = mis.instantiate()
		
		self.add_child(out)
		out.set_target(target)
		five_frames = 0
		
	five_frames += 1
