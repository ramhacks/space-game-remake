extends Tower

class_name Battery


var upgrade_level = 1

#How much energy it is producing every tick/pulse


var current_energy_usage


#How much power does this node store?
var upgrade_map = {
	1: 50, 
	2: 100,
	3: -1 #make the last item in the dictionary always be -1
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
	super._process(delta)
	
	
func upgrade(upgrade_type):
	self.build_progress = 0
	self.built = false
	
	
	Globals.power_groups[self.group_][1] -= power_capacity
	self.power_capacity = upgrade_map[upgrade_level]
	Globals.power_groups[self.group_][1] += power_capacity
	
	
