extends Tower

class_name Battery


var upgrade_level = 1

#How much energy it is producing every tick/pulse
var reset_energy = false
var set_energy = false
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

func do_process():
	#Make sure to only set new power capactiy after the tower is built
	# only need to set reset_energy when first built as upgrade function handels it
	if !self.built and !reset_energy:
		Globals.power_groups[self.group_][1] -= power_capacity
		reset_energy = true
	elif !set_energy and self.built:
		Globals.power_groups[self.group_][1] += power_capacity
		set_energy = true
	super.do_process()

func upgrade(upgrade_type):
	self.build_progress = 0
	self.built = false
	set_energy = false
	Globals.power_groups[self.group_][1] -= self.power_capacity
	self.power_capacity = self.current_upgrade_node.custom_vars_dict["Power_Capacity"] #Power capacity for current level
