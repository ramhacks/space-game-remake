extends Node2D



func gen_float_list(transformy, asteroid_sep):
	var floatlist = [0]
	while floatlist[len(floatlist)-1] < transformy*-1:
		floatlist.append(floatlist[len(floatlist)-1]+asteroid_sep)
	
	floatlist.pop_back()
	return floatlist
	
	
func _ready() -> void:
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	
	var angle = 11 #w

	var height = 270 # how tall it is, every iteration make smaller to generate asteroid along it
	var width =  200 #how wide the wave is
   


	var transformx = int(-(get_viewport_rect().size.x/2)+(get_viewport_rect().size.x/50))
	var transformy = int(-(get_viewport_rect().size.y/2))

	var center = [int(get_viewport_rect().size.x/2), transformy*-1]
   
	var place_chance = 15 #chance of placing asteroid, right now it is 10%
   #change it so that generates more toward center point 
   #do this by getting distance from center, the closer it is the higher the chance of placing it


	var asteroid_x_spread = 10 #spread of asteroids over the x-axis
   

	var loopamount = 16 #amount of times to iterate over smaller wave
	for j in range(0, loopamount):
		var random_chance_change = random.randf_range(1.5,2)
		var asteroid_separation = random.randf_range(1, 3)  #amount asteroids are separated over the x axis
		var loop = gen_float_list(transformy, asteroid_separation)
		for i in loop:
			var x_pos = i*asteroid_x_spread # multiple by a constant to spread out the points
			var y_pos = (height/(1+((x_pos+transformx)/width)**2))-transformy # plot the function
			
			#have to find a way to tilt the wave
			var distance = sqrt(((center[0]-x_pos)**2)+(center[1]-y_pos)**2) # calculate the distance from the center point (this will change when we make the center point 0, 0)
			var place = random.randi_range(0, int(distance))
			if(place < place_chance and x_pos < get_viewport_rect().size.x):
				var jiggle_asteroid = random.randi_range(-50, 50)  #if place is less then 10 place asteroid
				var asteroid = preload( "res://Asteroid_Gen/asteroid.tscn")
				
				
				var s = asteroid.instantiate()
				s.get_node("Sprite2D").set_random_size()
				
				s.get_node("Sprite2D").assign_full_texture()
				s.position.x = x_pos + jiggle_asteroid
				s.position.y = y_pos
				self.add_child(s)
		
		for i in loop:
			var x_pos = i*asteroid_x_spread # multiple by a constant to spread out the points
			var y_pos = (height*-1)/(1+((x_pos+transformx)/width)**2)-transformy # plot the function
			
			#have to find a way to tilt the wave
			var distance = sqrt(((center[0]-x_pos)**2)+(center[1]-y_pos)**2) # calculate the distance from the center point (this will change when we make the center point 0, 0)
			var place = random.randi_range(0, int(distance))
			if(place < place_chance and x_pos < get_viewport_rect().size.x):
				var jiggle_asteroid = random.randi_range(-50, 50)  #if place is less then 10 place asteroid
				var asteroid = preload( "res://Asteroid_Gen/asteroid.tscn")
				
				var s = asteroid.instantiate()
				s.get_node("Sprite2D").set_random_size()
				s.get_node("Sprite2D").assign_full_texture()
				s.position.x = x_pos + jiggle_asteroid
				s.position.y = y_pos
				self.add_child(s)
		
			
		if(height > 0):
			#shrink the wave so we can generate asteroids inside the wave, this is how we make the asteroids to appear to look nateral
			height -= (j+(loopamount/random_chance_change))
		else:
			break
			
		
			

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
