extends Node

#Wave spawner for enemies
var enemy
var enemy_node

var radar_node
var enemy_marker
var enemy_marker_texture

@export var mob_cap: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	radar_node = preload("res://Visuals/Minimap_textures/radar_marker.tscn")
	enemy_marker_texture = load("res://Visuals/Minimap_textures/enemy.png")
	enemy = preload("res://Enemy/Enemy_Types/Power_Targeter.tscn")
	enemy_node = enemy.instantiate()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy(pos, type):
	#Enemy Loading code, will be moved here temporarily, when moved, you need to call everything below,
	#below we add the radar node, initialize the enemy and connect necessary signals so that the radar node can move
	#with the enemy, when moved you will have to bring a preloaded radar node as well and a preloaded enemy_node
	
	var enemy_marker = radar_node.instantiate()
	enemy_marker.texture = enemy_marker_texture
	enemy_marker.get_relative.connect(get_parent().get_node("Camera_Area").call_rel)
	
	get_parent().get_node("Camera_Area").send_rel.connect(enemy_marker.receive_relative)
	
	get_parent().create_radar_node.emit(enemy_marker)


	enemy_node = enemy.instantiate()
	self.add_child(enemy_node)
	enemy_node.initialize(type, enemy_marker, pos)
	
func spawn_new_wave():
	var enemy_count = 10
	#Spawn them all in a random location, they will spread out after picking a target, they all will pick a seperate target and go to
	# a point on their radius, then they will circle the tower and fire
	var random = RandomNumberGenerator.new()
	
	random.randomize()
	var random_x_range = random.randi_range(0, 1150)
	var random_y_range = [random.randi_range(-20, 0), random.randi_range(650, 750)]
	var ind = random.randi_range(0,1) 
	if(get_tree().get_nodes_in_group("tower_node").size() > 0):

		var behavior_array = ["Power", "Random"]
		
		
		
		
		
		
		for i in range(enemy_count):
			var x_jiggle = randi_range(-30, 30)
			if(get_tree().get_nodes_in_group("Enemies").size() < mob_cap):
				spawn_enemy(Vector2(random_x_range+x_jiggle,random_y_range[ind]),behavior_array[random.randi_range(0, 1)])

#
func _on_global_ticks_timeout() -> void:
	
	spawn_new_wave()
