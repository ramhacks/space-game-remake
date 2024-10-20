extends Area2D

var timer

var line_node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = self.get_node("Timer")
	timer.set_wait_time(2)
	timer.start()
	line_node = self.get_node("Mining_Laser")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		# Move as long as the key/button is pressed.
		position.x += 5
	elif Input.is_action_pressed("move_left"):
		position.x -= 5
	
	elif Input.is_action_pressed("move_down"):	
		position.y += 5
	
	elif Input.is_action_pressed("move_up"):
		position.y -= 5
	


func _on_timer_timeout() -> void:
	line_node.clear_points()
	self.get_node("Sprite2D").mine(line_node)
	
	timer.start()
	
