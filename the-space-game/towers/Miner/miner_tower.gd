extends Tower

class_name Miner


var connect_health

var total_mined = 0
var mpm = 0
var timer
var placed = false

# Called when the node enters the scene tree for the first time.

func _ready() -> void:

	sprite_node = self.get_node("Sprite")
	child_area = self.get_node("Collision_Area")
	animated_node = self.get_node("Sprite_Node/Sprite2D")

	inherted_node = self
	show_colliding_bodies = true
	var current_animation : String = animated_node.animation

	sprite_texture = animated_node.get_sprite_frames().get_frame_texture(current_animation, 0)

	place_build_progress_bar()
	super._ready()
	mpm = self.current_upgrade_node.custom_var



func do_process():
	animated_node.change_collision_list($Collision_Area.get_overlapping_bodies())

	if built:
		if(animated_node):
			total_mined += animated_node.mine(line_node)
	super.do_process()

#overwrite set_placed:
func set_placed(re_animate, current_overlapping_bodies):
	placed = true
	super.set_placed(re_animate, current_overlapping_bodies)
	Globals.RPM += mpm * 60

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)


func _on_sprite_2d_draw_line(pos1: Variant, pos2: Variant) -> void:
	cooling_down = true

	draw_laser.emit(self, pos1, pos2, cooldown_delay, self)

func upgrade(upgrade_type):
	print("Upgrade")
	#Change how RPM is calculated with new energy system
	if(animated_node.upgrade_level < 3):
		Globals.RPM -= mpm * 60
		#have to subtract it so we don't just add more cause then we would double it
		animated_node.upgrade_level += 1
		Globals.RPM += self.current_upgrade_node.custom_var * 60
		mpm = self.current_upgrade_node.custom_var

func get_overlap():
#overlapping bodies (for asteroid detection)		#overlapping areas to make sure we are not on top of another node
	return child_area.get_overlapping_bodies()


func _on_tree_exiting() -> void:
	if placed:
		Globals.RPM -= mpm * 60
