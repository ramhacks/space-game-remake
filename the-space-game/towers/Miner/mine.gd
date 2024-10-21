extends Area2D

var cur_name = "miner"

var timer

var line_node

var child

var loaded = false

var powered = false #is this node powered? once set to true it will mine once


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	child = self.get_node("Sprite2D")
	timer = self.get_node("Timer")
	timer.set_wait_time(2)
	timer.start()
	line_node = self.get_node("Mining_Laser")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		#simulate the node getting power
		powered = true
	
	


func _on_timer_timeout() -> void:

		
	#if powered mine, else on the next 2 sec cycle delete the mining laser graphic
	if(!powered):
		line_node.clear_points()
		
		powered = true #remove 
		
	else:
		child = self.get_node("Sprite2D")
		if(child):
			child.mine(line_node)
		powered = false
	
	
	timer.start()
	


func _on_body_entered(body: Node2D) -> void:
	child.change_collision_list(body)
