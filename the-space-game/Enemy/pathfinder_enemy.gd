extends CharacterBody2D

var speed = 200
var accel = 1

var distance_size = 30

var prev_point: Vector2
var direction: Vector2

var first_move = true
var five_frames = 0
@onready var nav: NavigationAgent2D = $NavigationAgent2D
var start_targeting = false


signal tower_removed

func _ready():
	$StateMachine.start_ai()
	
func _process(delta: float) -> void:
	pass
	
func set_target():
	
	$StateMachine.start_ai()
	
func get_new_target():
	randomize()
	if(get_tree().get_nodes_in_group("tower_node").size() == 0):
		assert(3 == 2, "GAME OVER")
	var targ = get_tree().get_nodes_in_group("tower_node")[randi() % get_tree().get_nodes_in_group("tower_node").size()]
	return targ

func _on_surround_send_laser(target: Variant) -> void:

	if(five_frames == 5):
	#create line node 
	# 3 points, 
	#1st is self(pos1) position
	#2nd is pos2 position
	#3rd is self(pos1) position again
		var line = $Laser

		line.clear_points()
		self.add_child(line)
		line.add_point(to_local(self.global_position))
		if(is_instance_valid(target)):
			line.add_point(to_local(target.global_position))
		else:
			tower_removed.emit()
			return
		line.add_point(to_local(self.global_position))
		five_frames = 0
	else:
		five_frames += 1

#
#func recalculate_circle_points():
	#var surround_points = $StateMachine/Surround.PointsInCircum(distance_size, $StateMachine.target_node.global_position)
	#$StateMachine/Surround.surround_points = surround_points
	#
	#print(Globals.kthSmallest(surround_points, 0, len(surround_points)-1, 1))
	#print(surround_points)
	#
