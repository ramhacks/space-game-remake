extends Control



func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_restart_pressed() -> void:
	var scene: PackedScene = load("res://GameScenes/survival.tscn")
	var instance = scene.instantiate()

	get_tree().root.add_child(instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = instance
