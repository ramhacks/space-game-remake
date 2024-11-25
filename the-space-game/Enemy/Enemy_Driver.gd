extends CharacterBody2D

var radar_marker: Radar

var Targeting: Dictionary = {
	"Random": "Targeting/Random_Target",
	"Power": "Targeting/Power_Target"
}

var target_strat: String

@export var health = 10

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

#Run this before anything else
func initialize(target_method, radar, start_position):
	self.global_position = start_position
	target_strat = target_method
	radar_marker = radar
	$StateMachine.start_ai()

func enemy_death():
	radar_marker.queue_free()
	self.queue_free()
	
	
func _process(delta: float) -> void:
	radar_marker.on_update_location(self.global_position)	
	
	if health <= 0:
		enemy_death()
	

	
func get_new_target():
	
	if(get_tree().get_nodes_in_group("tower_node").size() == 0):
		assert(3 == 2, "GAME OVER")
		
	var out = self.get_node(Targeting[target_strat]).get_target()
	if(out == null):
		enemy_death()
		
	else:
		return out
	

func _on_surround_send_laser(target: Variant) -> void:
	print("attack")
	if five_frames == 10:
		if(is_instance_valid(target) and self.global_position.distance_to(target.global_position) > 50):
			
			self.get_node("StateMachine/Surround").Transitioned.emit(self, 'Chase')	
			return
			
		if(!is_instance_valid(target)):
			self.get_node("StateMachine").target_node = get_new_target()
			
		var out = mis.instantiate()
		
		self.add_child(out)
		out.set_target(target)
		five_frames = 0
		
	five_frames += 1
