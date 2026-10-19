extends Node

signal wave_start(int)


#Wave spawner for enemies
var enemy
var enemy_node

var radar_node
var enemy_marker
var enemy_marker_texture
var random = RandomNumberGenerator.new()

var cooldown_node




var current_budget = 0


@export var first_wave_delay := 20.0
@export var base_prep_time := 15.0
@export var max_wave_duration := 60.0   # failsafe so a stuck enemy can't stall the game


var wave_in_effect := false
var wave_elapsed := 0.0

var enemies_alive = []; # List of enemies alive if empty wave has been defeated

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
	"siege": 5,
}

const FORCED_THEMES = {
	1: "swarm",
	3: "economy_raid",
	5: "siege",
}

const ENEMY_COST = {"random": 1, "power": 3, "defense": 4}
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	radar_node = preload("res://Visuals/Minimap_textures/radar_marker.tscn")
	enemy_marker_texture = load("res://Visuals/Minimap_textures/enemy.png")
	cooldown_node = $CooldownEnemy

	enemy = preload("res://Enemy/Enemy_Types/Power_Targeter.tscn")
	enemy_node = enemy.instantiate()
	random.randomize()
	for t in THEMES:
		last_seen[t] = 0

	$CooldownEnemy.one_shot = true
	$CooldownEnemy.timeout.connect(_on_cooldown_timeout)
	$CooldownEnemy.start(first_wave_delay)

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
	self.add_child(enemy_node)
	enemies_alive.append(enemy_node)
	enemy_node.initialize(type, enemy_marker2, pos)


func _weakness_bonus(theme: String, game_state) -> float:
	if game_state == null:
		return 0.0
	if theme == "siege" and game_state.defense_strength < 5.0:
		return 2.0
	if theme == "economy_raid" and game_state.power_redundancy < 2:
		return 2.0
	return 0.0

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
func pick_theme(w: int, game_state = null) -> String:
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
				weights.append(1.0 + waves_since + _weakness_bonus(t, game_state))

		choice = candidates[_weighted_index(weights)]

	last_seen[choice] = w
	last_theme = choice
	return choice

func build_wave(w: int, game_state = null) -> Array[String]:
	var budget := get_budget(w)
	var theme := pick_theme(w, game_state)
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
		if get_tree().get_nodes_in_group("Enemies").size() >= mob_cap:
			break
		var x_jiggle = randi_range(-30, 30)
		spawn_enemy(Vector2(random_x_range + x_jiggle, random_y_range[ind]), behavior)


	wave_start.emit(Globals.wave_number)

func start_wave() -> void:
	# Nothing to attack yet, so wait a bit and check again
	if get_tree().get_nodes_in_group("tower_node").size() == 0 or Globals.paused:
		$CooldownEnemy.start(5.0)
		return

	Globals.wave_number += 1
	wave_in_effect = true
	wave_elapsed = 0.0

	spawn_new_wave(Globals.wave_number)



func _process(delta: float) -> void:
	if !wave_in_effect:
		return

	wave_elapsed += delta
	var cleared := get_tree().get_nodes_in_group("Enemies").size() == 0
	if cleared or wave_elapsed >= max_wave_duration:
		end_wave()

func end_wave() -> void:
	wave_in_effect = false
	$CooldownEnemy.start(get_prep_time(Globals.wave_number))


func get_prep_time(w: int) -> float:
	var t := base_prep_time
	if w % 5 == 0:
		t += 8.0   # extra recovery after a spike wave
	if (w + 1) % 5 == 0:
		t += 5.0   # extra time to build up before the next spike
	return t
