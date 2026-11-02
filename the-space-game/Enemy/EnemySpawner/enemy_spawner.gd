extends Tower

# Enemies that this tower spawns are not considered part of the wave

class_name EnemySpawner
var enemy_marker
var enemy_marker_texture
var enemy
var enemy_node
var radar_node
var wave_active = false

@export var self_mob_cap: int = 5
#Will extend tower but will ignore power generation and all that stuff

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_node = self.get_node("Sprite")
	child_area = self.get_node("Collision_Area")
	animated_node = self.get_node("Sprite_Node/Sprite2D")
	sprite_texture = animated_node.get_sprite_frames().get_frame_texture("default", 0)
	radar_node = preload("res://Visuals/Minimap_textures/radar_marker.tscn")
	enemy_marker_texture = load("res://Visuals/Minimap_textures/enemy.png")
	enemy = preload("res://Enemy/Enemy_Types/Power_Targeter.tscn")
	inherted_node = self
	$collider.hide()
	$BuildProgress.hide()
	super._ready()

func initialize(radar, pos: Vector2) -> void:
	radar_marker = radar
	self.global_position = pos
	print(radar_marker)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func upgrade(upgrade_type):
	pass


func _on_collision_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent() #Get actual tower node not the area we collided with
	if parent is Tower and parent.custom_class != "Enemy": #Make sure it isnt just us coliding with another enemy tower
		if !parent.hovering:
			pass


func _on_spawn_delay_timeout() -> void:
	if get_tree().get_nodes_in_group("spawned_enemy").size() >= self_mob_cap:
		$SpawnDelay.start()
		return

	var enemy_marker2 = radar_node.instantiate()
	enemy_marker2.texture = enemy_marker_texture
	enemy_marker2.get_relative.connect(get_parent().CameraArea.call_rel)

	get_parent().CameraArea.send_rel.connect(enemy_marker2.receive_relative)

	get_parent().call_radar(enemy_marker2)


	enemy_node = enemy.instantiate()
	enemy_node.add_to_group("wave_enemies")
	enemy_node.add_to_group("spawned_enemy")
	self.add_child(enemy_node)
	enemy_node.initialize('random', enemy_marker2, self.position)
	#Spawn new enemy here, they will alwyas be random target enemies
	$SpawnDelay.start()

func activate_tower() -> void:
	$SpawnDelay.start()
	animated_node.play("active")

func deactivate_tower() -> void:
	$SpawnDelay.stop()
	animated_node.play("default")
