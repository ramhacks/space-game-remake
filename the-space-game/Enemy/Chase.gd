extends State
class_name Chase


#Surround anchor distance must be larger than distance_size
@export var enemy: CharacterBody2D
@export var nav: NavigationAgent2D

var pos_set = false

var current_target: Tower
var target_acquired = false

var move_direction: Vector2

func Enter():
	pos_set = false
	
func Update(delta: float):
	if not pos_set and is_instance_valid(self.get_parent().target_node):
		randomize()
		var angle = randf_range(-90, 90)
		nav.target_position = enemy.point_circle(self.get_parent().target_node.global_position, angle)
		pos_set = true
	#Change so its not just the first tower in a group, make it actively target things
	

	if(!(is_instance_valid(self.get_parent().target_node) and self.get_parent().target_node.get_node("Health").health_amount > 0)):
		self.get_parent().target_node = enemy.get_new_target()

	if(is_instance_valid(self.get_parent().target_node)):
		#self.get_parent().target_node.get_node("Sprite/CollisionShape2D").shape.radius + 60
		if(enemy.global_position.distance_to(nav.target_position) < enemy.distance_size):
			Transitioned.emit(self, 'Surround')


func Physics_Update(delta: float):
	if is_instance_valid(self.get_parent().target_node):

		move_direction = Vector2()
		move_direction = nav.get_next_path_position() - enemy.global_position
			
		move_direction = move_direction.normalized()

				
		enemy.velocity = enemy.velocity.lerp(move_direction * enemy.speed, enemy.accel * delta)

		enemy.move_and_slide()
				
		enemy.look_at(nav.target_position)
	else:
		self.get_parent().target_node = enemy.get_new_target()

			
