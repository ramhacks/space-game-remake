extends Sprite2D
#Attached to each asteroid object defines its properties

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello, my name is: ")

func setname(name):
	print(name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
