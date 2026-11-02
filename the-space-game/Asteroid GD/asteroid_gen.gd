extends Node2D

#const Asteroids = preload("/home/logan/Documents/space-game-remake/the-space-game/enums/asteroid_generation_enum.gd").Configerations

var solar_pos = Vector2(1152/2, 648/2)
@export var max_radius_circle = 350
@export var min_radius_circle = 130
@export var spawn_margin = 30.0   # minimum gap past the farthest asteroid
@export var spawn_band = 150.0    # how much farther out the point may land

const JIGGLE = 50.0
const WAVE_HEIGHT = 270.0
const WAVE_WIDTH = 200.0
var place_chance = 10
var transformx: int
var transformy: int
var center: Array



func gen_float_list(transform_y, asteroid_sep):
	var floatlist = [0]
	while floatlist[len(floatlist)-1] < transform_y*-1:
		floatlist.append(floatlist[len(floatlist)-1]+asteroid_sep)

	floatlist.pop_back()
	return floatlist

# AI
func get_ordered_spaced_randoms(min_val: float, max_val: float, count: int, min_gap: float = 20.0) -> Array[float]:
	var result: Array[float] = []
	var current_min = min_val

	for i in range(count):

		# Reserve enough remaining distance for the remaining elements
		var max_possible = max_val - (count - 1 - i) * min_gap
		if current_min > max_possible:
			push_warning("Range too small to fit requested count with gap of " + str(min_gap))
			break

		var next_val = randf_range(current_min, max_possible)
		result.append(next_val)
		current_min = next_val + min_gap

	return result

# END AI

func double_wave(random) -> void:
	var height = 270 # how tall it is, every iteration make smaller to generate asteroid along it
	var width =  200 #how wide the wave is



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

func circle_form(random) -> void:
	# Center should be position of first spawned solar generator
	var loop_amount = 10
	var radius_list = get_ordered_spaced_randoms(min_radius_circle, max_radius_circle, loop_amount, 12)


	for radius in radius_list:
		var num_points = randi_range(1, 30)
		for z in range(num_points):
			var angle = 2.0 * PI * (float(z) / num_points)
			var spawn_pos = solar_pos + Vector2.from_angle(angle) * radius
			var place = random.randi_range(0, 10)
			if(place < place_chance and spawn_pos.x < get_viewport_rect().size.x):
				var asteroid = preload( "res://Asteroid_Gen/asteroid.tscn")
				var s = asteroid.instantiate()
				var jiggle_asteroid = random.randi_range(-50, 50)
				s.get_node("Sprite2D").set_random_size()
				s.get_node("Sprite2D").assign_full_texture()
				s.position.x = spawn_pos.x + jiggle_asteroid
				s.position.y = spawn_pos.y + jiggle_asteroid
				self.add_child(s)




func _ready() -> void:
	var vp = get_viewport_rect().size
	transformx = int(-(vp.x / 2) + (vp.x / 50))
	transformy = int(-(vp.y / 2))
	center = [int(vp.x / 2), transformy * -1]
	var random = RandomNumberGenerator.new()
	random.randomize()

	var out = random.randi_range(0, 1)
	if out == 0:
		Globals.asteroid_generation_type = "Circle"
		circle_form(random)
	else:
		Globals.asteroid_generation_type = "Wave"
		double_wave(random)

# AI
@export_range(1.0, 5.0) var closeness_bias = 3.5  # 1 = even spread, higher = hugs the circle

func circle_reach() -> float:
	return max_radius_circle + JIGGLE * sqrt(2)

func circle_pos_annulus() -> Vector2:
	var r_min = circle_reach() + spawn_margin
	var r_max = r_min + spawn_band
	# raising a 0-1 value to a power pushes results toward 0, which is the inner edge
	var t = pow(randf(), closeness_bias)
	var r = lerp(r_min, r_max, t)
	return solar_pos + Vector2.from_angle(randf() * TAU) * r

@export var wave_margin = 10.0
@export var wave_band = 40.0
@export_range(1.0, 5.0) var wave_closeness_bias = 3.0

func wave_envelope(x: float) -> float:
	var vp = get_viewport_rect().size
	var tx = -(vp.x / 2) + (vp.x / 50)   # same as transformx
	return WAVE_HEIGHT / (1.0 + pow((x + tx) / WAVE_WIDTH, 2))

func wave_pos_envelope() -> Vector2:
	var vp = get_viewport_rect().size
	var x = randf_range(-JIGGLE, vp.x + JIGGLE)

	# asteroids jiggle +/- 50 on x, so take the tallest envelope value within that window.
	# The curve peaks at the center, so clamp the peak into the window to find it.
	var peak_x = vp.x / 2 - vp.x / 50
	var worst_x = clamp(peak_x, x - JIGGLE, x + JIGGLE)
	var env = wave_envelope(worst_x)

	var side = 1.0 if randf() < 0.5 else -1.0   # above or below
	var offset = env + spawn_margin + randf_range(0.0, spawn_band)
	return Vector2(x, vp.y / 2 + side * offset)

#END AI
