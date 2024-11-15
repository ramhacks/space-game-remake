extends Tower

var upgrade_level = 1
var energy_limit = 300

var connect_toggle = false

var current_energy_usage

#adjacency list of the subgraph that this solar station has influence over and can direct power to
#will be used to draw better lines to nodes
var subgraph_of_influence = {
	
}



var upgrade_map = { #this upgrade map corresponds to the timeout rate of each solar station, or rate that it powers on 
	1: 2, #3 seconds
	2: 1.75,#2.5 seocnds
	3: 1.5, #2 seconds
	4: -1 #make the last item in the dictionary always be -1
}

var energy = 0

var current_animation : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_node = self.get_node("Sprite")
	child_area = self.get_node("Collision_Area")
	animated_node = self.get_node("Sprite2D")
	inherted_node = self
	
	$Power_Delay.wait_time = upgrade_map[upgrade_level]
	
	current_animation = animated_node.animation
	
	sprite_texture = animated_node.get_sprite_frames().get_frame_texture(current_animation, 0)
	super._ready()
	
	
func get_overlap():
	return [1,2,3] #placeholder as we don't need to check for overlapping asteroids, will need to check for nodes however

func _process(delta: float) -> void:
	if Globals.NO_SOLAR_TOWER and not Globals.tower_hovering:
		self.get_node("BuildProgress").set_visible(false)
		built = true
		build_progress = 100

		Globals.NO_SOLAR_TOWER = false
		
	if built and !connect_toggle:
		$Power_Delay.timeout.connect(turn_on)  
		$Power_Delay.start()
		connect_toggle = true #makes it so this command is only ran once we do not need to keep connecting the timeout signal
	
	super._process(delta)


#will need to change as I think for upgrades it makes the solar station generate power faster

func set_placed(re_animate, current_overlapping_bodies):
	for node in current_overlapping_bodies:
		if is_instance_valid(node):
			$Connector.add_point(to_local(self.global_position))
			$Connector.add_point(to_local(node.global_position))
		
		
		
	super.set_placed(re_animate, current_overlapping_bodies)

 
		
	
func turn_on():
	$Sprite.connections = $Collision_Area.get_overlapping_areas()
	#traverse_graph_power($Sprite, energy_limit)
	
	


#called when this tower is upgraded, called once per upgrade, upgrade level is changed by a script in survival, the side button script
func upgrade():
	$Power_Delay.wait_time = upgrade_map[upgrade_level]
	$Power_Delay.start()
