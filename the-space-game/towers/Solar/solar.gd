extends Tower

var upgrade_level = 1
var energy_limit = 300


var upgrade_map = {
	1: 10,
	2: 20,
	3: -1
}

var energy = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_node = self.get_node("Sprite")
	child_area = self.get_node("Collision_Area")
	animated_node = self.get_node("Sprite2D")
	inherted_node = self
	
	var current_animation : String = animated_node.animation
	
	sprite_texture = animated_node.get_sprite_frames().get_frame_texture(current_animation, 0)
	
	place_build_progress_bar()
	
func get_overlap():
	return [1,2,3] #placeholder as we don't need to check for overlapping asteroids, will need to check for nodes however

func _process(delta: float) -> void:
	if Globals.NO_SOLAR_TOWER and not Globals.tower_hovering:
		self.get_node("BuildProgress").set_visible(false)
		built = true
		build_progress = 100
		Globals.global_power_timer_on.timeout.connect(turn_on)   #start tower functionality
		Globals.NO_SOLAR_TOWER = false
	elif built:
		Globals.global_power_timer_on.timeout.connect(turn_on)  
	super._process(delta)


func do_process():
	pass


#will need to change as I think for upgrades it makes the solar station generate power faster

func set_placed(re_animate, current_overlapping_bodies):
	

	for node in current_overlapping_bodies:
		if is_instance_valid(node):
			$Connector.add_point(to_local(self.global_position))
			$Connector.add_point(to_local(node.global_position))
		
		
		
	super.set_placed(re_animate, current_overlapping_bodies)


	
func turn_on():
	traverse_graph_power($Sprite, energy_limit)
	
