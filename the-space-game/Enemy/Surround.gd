extends State

#Instead of using a nav agent to circle the enemy we are just going to follow a path to do so
class_name Surround

@export var enemy: CharacterBody2D
@export var nav: NavigationAgent2D


var distance_size = 30
var surround_points: Array = []
var move_direction


var current_angle = 0

var closest: Vector2
signal send_laser(target)
var current_point_iter = 0

var anchor_distance = 50
#Rotate around target node
var target_node: Tower

var circling = false

var cur_progress_ratio: float



func Enter():
	nav.target_position = next_point(self.get_parent().target_node.global_position, enemy.global_position, current_angle)
	#nav.target_position = target_node.global_position + Vector2.RIGHT.rotated((current_angle + 20) % 360)*30

func Update(delta:float):
	if get_parent().current_state == self:
		
		send_laser.emit(self.get_parent().target_node)

func _on_enemy_tower_removed() -> void:
	Transitioned.emit(self, 'Chase')


func next_point(tower_point, p, angle):
	var s = sin(angle)
	var c = cos(angle)
	p.x -= tower_point.x
	
	p.y -= tower_point.y
	
	var xnew = p.x * c - p.y * s;
	var ynew = p.x * s + p.y * c;
	p.x = xnew + tower_point.x;
	p.y = ynew + tower_point.y;
	
	
	return p;


func Physics_Update(delta: float):
	if(!is_instance_valid(self.get_parent().target_node)):
		self.get_parent().target_node = enemy.get_new_target()
		
	if(!(enemy.global_position.distance_to(nav.target_position) > 30)):
		
		nav.target_position = next_point(self.get_parent().target_node.global_position, enemy.global_position, 5)
	
	if(!is_instance_valid(self.get_parent().target_node)):
		self.get_parent().target_node = enemy.get_new_target()
	
		
	if(is_instance_valid(self.get_parent().target_node)):
		if(enemy.global_position.distance_to(self.get_parent().target_node.global_position) > anchor_distance):
			Transitioned.emit(self, 'Chase')	

	if is_instance_valid(self.get_parent().target_node):

		move_direction = Vector2()
		move_direction = nav.get_next_path_position() - enemy.global_position
			
		move_direction = move_direction.normalized()

				
		enemy.velocity = enemy.velocity.lerp(move_direction * enemy.speed, enemy.accel * delta)

		enemy.move_and_slide()
				
		enemy.look_at(self.get_parent().target_node.global_position)
