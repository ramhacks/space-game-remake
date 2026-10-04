extends Node

#Wave spawner for enemies
var enemy
var enemy_node

var radar_node
var enemy_marker
var enemy_marker_texture
var random = RandomNumberGenerator.new()

var cooldown_node


var wave_in_effect = false # IF currently in an enemy wave
var enemies_alive = []; # List of enemies alive if empty wave has been defeated

@export var mob_cap: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	radar_node = preload("res://Visuals/Minimap_textures/radar_marker.tscn")
	enemy_marker_texture = load("res://Visuals/Minimap_textures/enemy.png")
	cooldown_node = $CooldownEnemy

	enemy = preload("res://Enemy/Enemy_Types/Power_Targeter.tscn")
	enemy_node = enemy.instantiate()



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

func spawn_new_wave(enemy_count):
	#Spawn them all in a random location, they will spread out after picking a target, they all will pick a seperate target and go to
	# a point on their radius, then they will circle the tower and fire


	random.randomize()
	var random_x_range = random.randi_range(0, 1150)
	var random_y_range = [random.randi_range(-20, 0), random.randi_range(650, 750)]
	var ind = random.randi_range(0,1)
	if(get_tree().get_nodes_in_group("tower_node").size() > 0):
		var behavior_array = ["Power", "Random", "Defense"]
		for i in range(enemy_count):
			var x_jiggle = randi_range(-30, 30)
			if(get_tree().get_nodes_in_group("Enemies").size() < mob_cap):
				spawn_enemy(Vector2(random_x_range+x_jiggle,random_y_range[ind]),behavior_array[random.randi_range(0, 2)])



# Enemy Spawn new wave in portions on various trigers,
#
# 1. if mineral wealth is above a certain limit
# 2. if energy wealth above a certain limit aim to lower that limit if possible
# func _on_global_ticks_timeout() -> void:
#
# 	spawn_new_wave()



func _process(delta: float) -> void:
	if (!wave_in_effect):
		var chances = [get_tree().get_nodes_in_group("tower_node").size() >= 3, Globals.resources > 1500]
		random.randomize()

		if (chances[random.randi_range(0, chances.size()-1)]):
			if (Globals.resources > 3000 and !wave_in_effect):
				spawn_new_wave(Globals.resources/10)
				wave_in_effect = true
		else:
			print("Chosen is false wait")
			$CooldownEnemy.wait_time = random.randi_range(5, 15)
			$CooldownEnemy.start()
			wave_in_effect = true
	#if (Globals.total_current > 200 and !wave_in_effect):
	# if !wave_in_effect:
	# 	print("Spawning Wave")
	# 	spawn_new_wave(5)
	# 	print("Enemy Wave can spawn")
	# 	wave_in_effect = true;


# When all enemies are dead start cooldown timer to give the player a chance to recover
func _on_child_exiting_tree(node: Node) -> void:
	if (get_tree().get_nodes_in_group("Enemies").size() == 0):
		random.randomize()
		$CooldownEnemy.wait_time = random.randi_range(60, 160)
		$CooldownEnemy.start()


func _on_cooldown_enemy_timeout() -> void:
	wave_in_effect = false
