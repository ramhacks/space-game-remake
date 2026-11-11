extends Control

func _on_start_pressed() -> void:
	$LevelType.show()
	$MainButtons.hide()



func _on_exit_pressed() -> void:
	get_tree().quit()

# Initiate the game scene as normal but set the tutorial flag to true before
# adding the child to set survival.gd to know that we need to spawn the tutorial scene overlay
# and disable enemies
func _on_tutorial_pressed() -> void:
	Globals.asteroid_generation_type = "Wave"
	var scene: PackedScene = load("res://GameScenes/survival.tscn")
	var instance = scene.instantiate()

	instance.activate_tutorial = true

	get_tree().root.add_child(instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = instance



func _on_back_pressed() -> void:
	$LevelType.hide()
	$MainButtons.show()


func _on_circle_pressed() -> void:
	Globals.asteroid_generation_type = "Circle"
	start_game()

func _on_square_pressed() -> void:
	Globals.asteroid_generation_type = "Wave"
	start_game()

#Add game scene to root then remove self from root
func start_game() -> void:
	var scene: PackedScene = load("res://GameScenes/survival.tscn")
	var instance = scene.instantiate()

	get_tree().root.add_child(instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = instance
