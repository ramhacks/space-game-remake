extends Sprite2D



#Script for each individual asteroid, this is the asteroid class


#public variables below

#892 - 932 //evens are full, odds are empty (start as random number between this but only even number


var resources = 10
var asteroid_size = 0


var max_size = 15

var texture_path
func _ready() -> void:
	pass

func set_random_size():
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	
	# fix so that larger numbers are generated not as often as the smaller numbers, put a weight to them
	self.asteroid_size = min(random.randi_range(892, 932), random.randi_range(892, 932), random.randi_range(892, 932)) 
	#--------------------------------------------------------
	
	var my_size = (892 + self.asteroid_size) % 15
	
	self.resources = my_size * 52
	
	
	if(self.asteroid_size % 2):
		if((self.asteroid_size + 1) > 932):
			self.asteroid_size = self.asteroid_size - 1
		else:
			self.asteroid_size = self.asteroid_size + 1
	self.texture_path = "res://Asteroid_Images/" + str(self.asteroid_size) + '.png' # need to fix, it is making the largest the smallest asteroids


func assign_full_texture():
	texture = load(self.texture_path) #assign full texture to self

func assign_empty_texture():
	self.texture_path = "res://Asteroid_Images/" + str(self.asteroid_size+1) + '.png'
	texture = load(self.texture_path)


func setresources(amount): #set resources
	self.resources = amount



func extractresources(change): #change resources by a certain amount, if no more resources return 0 if 
	#some left return 1
	if(self.resources > 0):
		if((self.resources - change) > 0):
			Globals.resources += change
		else:
			Globals.resources += self.resources
		self.resources -= change
		
		return 1
	else:
		#assign an empty texture if it is empty, this will rarly be called but is here just in case
		assign_empty_texture()
		return 0
	
	
	
