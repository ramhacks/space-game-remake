extends Control

@export var blink_amount: int = 0
@export var blink_delay: int

var blink_cycles = 0
var past_blinks = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Multiply by 2 because one blink is actually 2 timer timeouts
	$Timer.wait_time = blink_delay * 2
	$Timer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	past_blinks += 1
	if past_blinks % 2 == 0:
		blink_cycles += 1
	if blink_cycles >= blink_amount:
		#Done blinking remove self from scene tree
		self.queue_free()
	else:
		visible = !visible
	$Timer.start()
