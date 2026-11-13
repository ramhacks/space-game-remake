extends CharacterBody2D

class_name Enemy
# const EnemyEnums = preload("res://enums/enemy_enums.gd")

var radar_marker: Radar

var health_connected


var Targeting: Dictionary = {
	"random": "Targeting/Random_Target",
	"power": "Targeting/Power_Target",
	"defense": "Targeting/Defense_Target",
}

var EnemyTypeDamages: Dictionary = {
	"random": 5,
	"power": 7,
	"defense": 7
}

var EnemyTypeHealth: Dictionary = {
	"random": 5,
	"power": 10,
	"defense": 5
}

var target_strat: String

@export var health = 10

var speed:int = 150
var accel: int = 1

var missle_damage:int = 0

var distance_size: int = 60

var prev_point: Vector2
var direction: Vector2

var first_move: bool = true
var five_frames = 0

@onready var nav: NavigationAgent2D = $NavigationAgent2D

var start_targeting = false
var mis

# signal tower_removed

func point_circle(center, angle):
	var x = center.x + distance_size * cos(angle)
	var y = center.y + distance_size * sin(angle)

	return Vector2(x,y)


func next_point(tower_point, p, angle):
	p = point_circle(tower_point, angle)

	var s = sin(angle)
	var c = cos(angle)
	p.x -= tower_point.x

	p.y -= tower_point.y

	var xnew = p.x * c - p.y * s;
	var ynew = p.x * s + p.y * c;
	p.x = xnew + tower_point.x;
	p.y = ynew + tower_point.y;


	return p;

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	mis = preload("res://Enemy/missle.tscn")


#Run this before anything else
func initialize(target_method, radar, start_position):
	self.global_position = start_position
	target_strat = target_method
	health = EnemyTypeHealth[target_strat]
	missle_damage = EnemyTypeDamages[target_strat]
	radar_marker = radar
	self.get_node(Targeting[target_strat]).init_target()
	$StateMachine.start_ai()

func enemy_death():
	radar_marker.queue_free()
	self.queue_free()


func _process(delta: float) -> void:
	radar_marker.on_update_location(self.global_position)

	if health <= 0:
		enemy_death()



func get_new_target() -> Node2D:
	if get_tree().get_nodes_in_group("tower_node").is_empty():

		var scene: PackedScene = load("res://GameScenes/GameOver.tscn")
		var instance = scene.instantiate()

		get_tree().root.add_child(instance)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = instance
		return null

	var targeting = get_node(Targeting[target_strat])
	var out = targeting.get_target()

	if out is int and out == EnemyEnums.TargetFound.KILLSELF:
		enemy_death()
		return null

	if out is int and out == EnemyEnums.TargetFound.SWITCH_RANDOM:
		targeting.init_target()
		missle_damage = EnemyTypeDamages['random']
		health = min(health, EnemyTypeHealth['random'])
		# switch strategy happened; fetch a real node from the new strategy
		var new_out = get_node(Targeting[target_strat]).get_target()
		return new_out if new_out is Node2D else null

	return out as Node2D


func _on_surround_send_laser(target: Variant) -> void:

	if five_frames == 2:


		if(!is_instance_valid(target)):
			var output = get_new_target()
			if (output):
				self.get_node("StateMachine").target_node = output
			else:
				return


		var out = mis.instantiate()
		out.set_damage(missle_damage)

		self.add_child(out)
		out.set_target(target)
		five_frames = 0

	five_frames += 1

func _exit_tree() -> void:
	#If radar marker still exists delete it
	if is_instance_valid(radar_marker):
		radar_marker.queue_free()
