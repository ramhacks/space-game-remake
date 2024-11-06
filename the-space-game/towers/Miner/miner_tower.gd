extends Tower

var total_mined = 0
var mpm = 0
var timer 

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	sprite_node = self.get_node("Sprite")
	child_area = self.get_node("Collision_Area")
	animated_node = self.get_node("Sprite2D")
	inherted_node = self
	show_colliding_bodies = true
	
	timer = self.get_node("Timer") #The timer is in place of a power node, when we implement power, we won't need a timer
	timer.set_wait_time(2)
	var current_animation : String = animated_node.animation
	
	sprite_texture = animated_node.get_sprite_frames().get_frame_texture(current_animation, 0)
	
	place_build_progress_bar()
	


#overwrite set_placed:
func set_placed(re_animate, current_overlapping_bodies):
	timer.start()
	animated_node.change_collision_list(current_overlapping_bodies)
	super.set_placed(re_animate, current_overlapping_bodies)
	Globals.RPM += mpm
	
	
	
func _on_timer_timeout() -> void:	 
	if(!cooling_down and built):
		#if powered mine, else on the next 2 sec cycle delete the mining laser graphic
		if(animated_node):
			total_mined += animated_node.mine(line_node)
		
		cooling_down = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mpm = animated_node.upgrade_map[level]
	super._process(delta)
	
	
func _on_sprite_2d_draw_line(pos1: Variant, pos2: Variant) -> void:
	cooling_down = true

	draw_laser.emit(self, pos1, pos2, cooldown_delay, self) 

func upgrade():
	if(animated_node.upgrade_level < 3):
		Globals.RPM -= animated_node.upgrade_resource_drain[animated_node.upgrade_level] * 60/cooldown_delay
		#have to subtract it so we don't just add more cause then we would double it
		animated_node.upgrade_level += 1
		Globals.RPM += animated_node.upgrade_resource_drain[animated_node.upgrade_level] * 60/cooldown_delay
