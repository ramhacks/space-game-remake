extends Node

signal wave_start(int)
signal show_tower_warning
signal wave_active
signal wave_stopped
## Makes it so enemies will spawn in 30 seconds
@export var debug_mode: bool = false

## Makes it so mob cap is set to 0 on startup
@export var disable_enimies: bool = false
@export var CameraArea: Area2D = null
@export var break_time_jiggle: int = 0
@export var max_enemy_towers: int = 0
@export var ENEMY_TOWER_WAVE_SPAWN: int = 3
#Wave spawner for enemies
var enemy
var enemy_node

var radar_node
var enemy_marker
var enemy_marker_texture
var random = RandomNumberGenerator.new()
var enemy_spawner_tower
var cooldown_node
var game_over_scene



var current_budget = 0
var enemy_tower_warning

@export var first_wave_delay := 20.0
@export var base_prep_time := 60.0
@export var max_wave_duration := 60.0   # failsafe so a stuck enemy can't stall the game


var wave_in_effect := false
var wave_elapsed := 0.0

@export var mob_cap: int

const THEMES = {
	"swarm":        {"random": 0.8, "power": 0.1, "defense": 0.1},
	"economy_raid": {"random": 0.3, "power": 0.6, "defense": 0.1},
	"siege":        {"random": 0.3, "power": 0.1, "defense": 0.6},
	"mixed":        {"random": 0.4, "power": 0.3, "defense": 0.3},
}

const THEME_UNLOCK = {
	"swarm": 1,
	"mixed": 2,
	"economy_raid": 3,
	"siege": 4,
}



const FORCED_THEMES = {
	1: "swarm",
	3: "economy_raid",
	5: "siege",
}


# Costs of the enemy to unlock, how much the 'wave' spends, kind of determines how often enimies will spawn
const ENEMY_COST = {"random": 1, "power": 2, "defense": 3}
const ENEMY_UNLOCK = {"random": 1, "power": 3, "defense": 5}

var last_theme := ""
var last_seen := {}

func get_budget(w: int) -> float:
	var budget := 1.0 + 1.2 * w + 0.5 * pow(w, 1.1)
	if w % 4 == 0:
		budget *= 0.7
	if w % 5 == 0:
		budget *= 1.3
	return budget

#Lets children call this function via this node
func call_radar(node):
	get_parent().create_radar_node.emit(node)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func start_spawn():
	if debug_mode:
		first_wave_delay = 30
		base_prep_time = 60
		max_wave_duration = 60

	if disable_enimies:
		mob_cap = 0
	radar_node = preload("res://Visuals/Minimap_textures/radar_marker.tscn")
	enemy_marker_texture = load("res://Visuals/Minimap_textures/enemy.png")
	enemy_spawner_tower = preload("res://Enemy/EnemySpawner/EnemySpawner.tscn")
	enemy_tower_warning = preload("res://UI Scenes/enemytoweralert.tscn")

	cooldown_node = $CooldownEnemy

	enemy = preload("res://Enemy/Enemy_Types/Power_Targeter.tscn")
	enemy_node = enemy.instantiate()
	random.randomize()
	for t in THEMES:
		last_seen[t] = 0

	$CooldownEnemy.one_shot = true
	$CooldownEnemy.timeout.connect(_on_cooldown_timeout)
	$CooldownEnemy.start(first_wave_delay)

func prepare_enemy_tower_instance(tower_instance: EnemySpawner):

	wave_active.connect(tower_instance.activate_tower)
	wave_stopped.connect(tower_instance.deactivate_tower)
	#Spawn warning sign
	show_tower_warning.emit()

func _on_cooldown_timeout() -> void:
	start_wave()



# Current Task fix enemy animation not being correct
func spawn_enemy(pos, type):
	#Enemy Loading code, will be moved here temporarily, when moved, you need to call everything below,
	#below we add the radar node, initialize the enemy and connect necessary signals so that the radar node can move
	#with the enemy, when moved you will have to bring a preloaded radar node as well and a preloaded enemy_node
	var enemy_marker2 = radar_node.instantiate()
	enemy_marker2.texture = enemy_marker_texture
	enemy_marker2.get_relative.connect(get_parent().get_node("Camera_Area").call_rel)

	get_parent().get_node("Camera_Area").send_rel.connect(enemy_marker2.receive_relative)

	get_parent().create_radar_node.emit(enemy_marker2)


	enemy_node = enemy.instantiate()
	enemy_node.add_to_group("wave_enemies")
	self.add_child(enemy_node)
	enemy_node.initialize(type, enemy_marker2, pos)





# AI ASSISTED CODE BELOW


func _weighted_index(weights: Array[float]) -> int:
	var total := 0.0
	for x in weights:
		total += x
	var roll := random.randf() * total
	var running := 0.0
	for i in weights.size():
		running += weights[i]
		if roll <= running:
			return i
	return weights.size() - 1

# What type of wave is this
func pick_theme(w: int) -> String:
	var choice := ""

	if FORCED_THEMES.has(w):
		choice = FORCED_THEMES[w]
	else:
		var candidates: Array[String] = []
		var weights: Array[float] = []

		for t in THEMES:
			if w >= THEME_UNLOCK[t] and t != last_theme:
				candidates.append(t)
				var waves_since: int = w - last_seen[t]
				weights.append(1.0 + waves_since)
		choice = candidates[_weighted_index(weights)]

	last_seen[choice] = w
	last_theme = choice
	return choice

# Build the wave
func build_wave(w: int) -> Array[String]:
	var budget := get_budget(w)
	var theme := pick_theme(w)
	var theme_weights: Dictionary = THEMES[theme]
	var wave: Array[String] = []

	while true:
		var options: Array[String] = []
		var weights: Array[float] = []
		for e in ENEMY_COST:
			if w >= ENEMY_UNLOCK[e] and ENEMY_COST[e] <= budget:
				options.append(e)
				weights.append(theme_weights[e])

		if options.is_empty():
			break
		var picked := options[_weighted_index(weights)]
		wave.append(picked)
		budget -= ENEMY_COST[picked]


	return wave

# GEMENI QUICK AND DIRTY CHECK IF POSITON COLLIDING
func is_position_colliding(pos: Vector2, layer: int) -> bool:
	var space := get_viewport().world_2d.direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collision_mask = 1 << (layer - 1)  # layer is 1-32
	query.collide_with_areas = true
	query.collide_with_bodies = false  # set true if you want bodies too
	return space.intersect_point(query, 1).size() > 0

func spawn_new_wave(wave_number: int) -> void:
	# Spawn them all in a random location, they will spread out after picking a target,
	# they all will pick a separate target and go to a point on their radius,
	# then they will circle the tower and fire



	if get_tree().get_nodes_in_group("tower_node").size() == 0 or Globals.paused:
		return

	random.randomize()
	var random_x_range = random.randi_range(0, 1150)
	var random_y_range = [random.randi_range(-20, 0), random.randi_range(650, 750)]
	var ind = random.randi_range(0, 1)

	var enemies: Array[String] = build_wave(Globals.wave_number)
	for behavior in enemies:
		if get_tree().get_nodes_in_group("wave_enemies").size() >= mob_cap:
			break
		var x_jiggle = randi_range(-30, 30)
		spawn_enemy(Vector2(random_x_range + x_jiggle, random_y_range[ind]), behavior)


	# After wave 4 enemy spawners can spawn around the map
	if Globals.wave_number >= ENEMY_TOWER_WAVE_SPAWN:
		if get_tree().get_nodes_in_group("EnemyTowers").size() >= max_enemy_towers:
			return
		var spawn_pos: Vector2

		var attempts = 2

		for i in range(0, attempts):
			if Globals.asteroid_generation_type == "Circle":
				spawn_pos = get_parent().circle_point()
				if is_position_colliding(spawn_pos, 2):
					continue
				break
			else:
				spawn_pos = get_parent().wave_point()
				if is_position_colliding(spawn_pos, 2):
					continue
				break


		var enemy_marker3 = radar_node.instantiate()
		enemy_marker3.texture = enemy_marker_texture
		enemy_marker3.get_relative.connect(get_parent().get_node("Camera_Area").call_rel)
		enemy_marker3.on_update_location(spawn_pos)

		get_parent().get_node("Camera_Area").send_rel.connect(enemy_marker3.receive_relative)

		get_parent().create_radar_node.emit(enemy_marker3)

		var amount = random.randi_range(1, 2)
		for i in range(0, amount):
			if get_tree().get_nodes_in_group("EnemyTowers").size() >= max_enemy_towers:
				return
			var spawner = enemy_spawner_tower.instantiate()
			self.add_child(spawner)
			spawner.initialize(enemy_marker3, spawn_pos)

	wave_start.emit(Globals.wave_number)


#Start wave, activate all enemy spawner towers on board by emitting the tower signal
func start_wave() -> void:
	wave_active.emit()
	# Nothing to attack yet, so wait a bit and check again
	if get_tree().get_nodes_in_group("tower_node").size() == 0 or Globals.paused:
		$CooldownEnemy.start(5.0)
		return

	Globals.wave_number += 1
	wave_in_effect = true
	Globals.wave_active = true
	wave_elapsed = 0.0

	spawn_new_wave(Globals.wave_number)


#END AI ASSISTED CODE


func _process(delta: float) -> void:
	if !wave_in_effect:
		return

	wave_elapsed += delta
	var cleared = get_tree().get_nodes_in_group("wave_enemies").size() == 0
	if cleared:
		end_wave()




#End wave, deactivate all enemy tower spawners and restart cooldown timer
func end_wave() -> void:
	wave_stopped.emit()
	wave_in_effect = false
	Globals.wave_active = false
	$CooldownEnemy.start(get_prep_time(Globals.wave_number) + random.randf_range(0, break_time_jiggle))


func get_prep_time(w: int) -> float:
	var t = base_prep_time
	if w % 5 == 0:
		t += 20.0   # extra recovery after a spike wave
	if (w + 1) % 5 == 0:
		t += 30.0   # extra time to build up before the next spike
	return t
