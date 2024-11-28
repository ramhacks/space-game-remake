extends Tower

class_name Solar


var upgrade_level = 1

#How much energy it is producing every tick/pulse
var energy_produced = 100


var connect_toggle = true

var current_energy_usage

#adjacency list of the subgraph that this solar station has influence over and can direct power to
#will be used to draw better lines to nodes


#IF we want we can change the upgrade map to increase power capacity
var upgrade_map = { #this upgrade map corresponds to the timeout rate of each solar station, or rate that it powers on 
	1: 3, #3 seconds
	2: 2,#2.5 seocnds
	3: 1.5, #2 seconds
	4: -1 #make the last item in the dictionary always be -1
}


var energy = 0

var current_animation : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_node = self.get_node("Sprite")
	child_area = self.get_node("Collision_Area")
	animated_node = self.get_node("Sprite_Node/Sprite2D")
	inherted_node = self
	

	
	current_animation = animated_node.animation
	
	sprite_texture = animated_node.get_sprite_frames().get_frame_texture("hover", 0)
	
	super._ready()
	
	
	
func get_overlap():
	return [1,2,3] #placeholder as we don't need to check for overlapping asteroids, will need to check for nodes however

func _process(delta: float) -> void:
	if Globals.NO_SOLAR_TOWER and not Globals.tower_hovering:
		self.get_node("BuildProgress").set_visible(false)
		built = true
		build_progress = 100

		Globals.NO_SOLAR_TOWER = false
	
	if built and connect_toggle:
		$Power_Delay.wait_time = 0.5
		power_time_seconds = upgrade_map[upgrade_level]
		$Power_Delay.timeout.connect(turn_on)  
		$Power_Delay.timeout.disconnect(_on_power_delay_timeout)
		connect_toggle = false
		
	super._process(delta)


#will need to change as I think for upgrades it makes the solar station generate power faster

func set_placed(re_animate, current_overlapping_bodies):
	for node in current_overlapping_bodies:
		if is_instance_valid(node):
			$Connector.add_point(to_local(self.global_position))
			$Connector.add_point(to_local(node.global_position))
		
		
		
	super.set_placed(re_animate, current_overlapping_bodies)

func turn_on():
	#health = 0 For testing explosion animation
	if(Globals.power_groups[group_][0]+energy_produced <= Globals.power_groups[group_][1]):
		Globals.power_groups[group_][0] += energy_produced
		Globals.total_current += energy_produced
	
	


#called when this tower is upgraded, called once per upgrade, upgrade level is changed by a script in survival, the side button script
func upgrade():
	self.build_progress = 0
	self.built = false
	$Power_Delay.wait_time = upgrade_map[upgrade_level]
	$Power_Delay.timeout.disconnect(turn_on)
	$Power_Delay.timeout.connect(_on_power_delay_timeout)
	connect_toggle = true
	
