extends CanvasLayer

#Only exists to spawn the tutorial scene
var scene: PackedScene = load("res://GameScenes/tutorial.tscn")

func _on_survival_spawn_tutorial() -> void:
	var instance = scene.instantiate()
	add_child(instance)
