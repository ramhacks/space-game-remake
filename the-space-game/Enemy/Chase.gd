extends State
class_name Chase


@export var enemy: CharacterBody2D
@export var nav: NavigationAgent2D

var current_target: Tower
var target_acquired = false

var move_direction: Vector2

var backtracking = false

func Update(delta: float):
	
	#Change so its not just the first tower in a group, make it actively target things
	

	if(is_instance_valid(self.get_parent().target_node) and self.get_parent().target_node.health > 0):
		nav.target_position = self.get_parent().target_node.global_position
	else:

		self.get_parent().target_node = enemy.get_new_target()
	

			
	if(!(enemy.global_position.distance_to(nav.target_position) > self.get_parent().target_node.get_node("Sprite/CollisionShape2D").shape.radius + 60)):
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

			


func _on_navigation_agent_2d_navigation_finished() -> void:
	
	Transitioned.emit(self, 'Surround')
