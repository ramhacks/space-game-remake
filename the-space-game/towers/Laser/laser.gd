extends Tower

#Until laser is added this will be a laser tower
class_name Laser

signal tower_built

var projectile_type = "Laser"
var mis

var laser_upgrade_type = 'basic'


var upgrade_level = 1

var upgrade_map = {
	1: 10,
	2: -1
}

var thel_upgrade_price_map = {
	1: 500,
	2: 800,
	3: 1000,
	4:-1
}

var pulsar_upgrade_price_map = {
	1: 100,
	2: 150,
	3: 300,
	4:-1
}


var Thel_health_upgrade = {
	2:400,
	3:600,
	4:960
}

var Pulsar_health_upgrade = {
	2:300,
	3:500,
	4:900
}





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_node = self.get_node("Sprite")
	child_area = self.get_node("Collision_Area")
	animated_node = self.get_node("Sprite_Node/Sprite2D")
	$StateMachine.parent_node = self
	
	inherted_node = self
	show_colliding_bodies = true
	var current_animation : String = animated_node.animation
	
	sprite_texture = animated_node.get_sprite_frames().get_frame_texture(current_animation, 0)
	
	place_build_progress_bar()
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	super._process(delta)

func do_process():
	if built:
		tower_built.emit()
		
	super.do_process()

func return_local(pos):
	return to_local(pos)

func get_overlap():
	return [1,2,3] #placeholder as we don't need to check for overlapping asteroids, will need to check for nodes however


func upgrade(upgrade_type):
	if upgrade_type == "Pulsar":
		laser_upgrade_type = 'pulsar'
		#Change the upgrade maps
		upgrade_price = {
			2: -1,
			3: -1,
			4:0,
			5:-1
		}

		recycle_price = {
			2: 45,
			3: 45,
			4:0,
			5:0
		}
		$Health.health_amount = Pulsar_health_upgrade[level]
		$Health.max_health = Pulsar_health_upgrade[level]
	else:
		laser_upgrade_type = 'thel'
		upgrade_price = {
			2: 500,
			3: 800,
			4:1000,
			5:-1
		}

		upgrade_price = {
			2: -1,
			3: -1,
			4:0,
			5:-1
		}
		$Health.health_amount = Thel_health_upgrade[level]
		$Health.max_health = Thel_health_upgrade[level]
	
		
	$StateMachine.current_state.Transitioned.emit($StateMachine.current_state, upgrade_type)
	animated_node.play(upgrade_type+ "_level_" + str(level))
