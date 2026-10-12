extends State

#Instead of using a nav agent to circle the enemy we are just going to follow a path to do so
class_name Surround

@export var enemy: CharacterBody2D
@export var nav: NavigationAgent2D


var distance_size = 30
var surround_points: Array = []
var move_direction

var target_pos: Vector2

var current_angle = 0

var first_shot = false
var closest: Vector2
signal send_laser(target)
var current_point_iter = 0

var anchor_distance = 65


var circling = false

var cur_progress_ratio: float

var stand_still_time = 10 #10 frames until enemy target reset

func Enter():
	target_pos = self.get_parent().target_node.global_position
	nav.target_position = enemy.next_point(self.get_parent().target_node.global_position, enemy.global_position, current_angle)

	#nav.target_position = target_node.global_position + Vector2.RIGHT.rotated((current_angle + 20) % 360)*30



func _on_enemy_tower_removed() -> void:
	Transitioned.emit(self, 'Chase')





func Physics_Update(delta: float):
	if !Globals.paused:
		randomize()
		if(!is_instance_valid(self.get_parent().target_node)):
			self.get_parent().target_node = enemy.get_new_target()

		if(enemy.global_position.distance_to(nav.target_position) < 40 and enemy.global_position.distance_to(nav.target_position) > 30 and is_instance_valid(self.get_parent().target_node) and not first_shot):
			send_laser.emit(self.get_parent().target_node)
			first_shot = true

		if(enemy.global_position.distance_to(nav.target_position) < 20 and is_instance_valid(self.get_parent().target_node)):
			var angle = randf_range(-10, 10)

			current_angle = angle
			nav.target_position = enemy.point_circle(self.get_parent().target_node.global_position, angle)
			#nav.target_position = enemy.next_point(self.get_parent().target_node.global_position, enemy.global_position, angle)
			send_laser.emit(self.get_parent().target_node)
			first_shot = false

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
