extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random = RandomNumberGenerator.new()
	random.randomize()
	var min_x_pos=100 #this scales the wave/makes it wider
   #as we get bigger, scale up asteroid field
	var max_x_pos=200
   
	var min_y_pos=150 #minimum y and max, this is how tall the wave can be
	var max_y_pos=300
	
	var d = -0.1
	for i in range(0, 5):
		for j in range(0, int(i/2)):
			var y = random.randi_range(min_y_pos, max_y_pos)
			var threshold2 = -(d*i)**2
			
			
	for i in range(3):
		var asteroid = preload( "res://Asteroid_Scripts/asteroid.tscn" )
		var s = asteroid.instantiate()
		s.position.x = 200 + (i*30)
		s.position.y = 200
		self.add_child(s)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
