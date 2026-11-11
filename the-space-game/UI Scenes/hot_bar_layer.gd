extends CanvasLayer

signal tutorial_finished()

#Only exists to spawn the tutorial scene
var scene: PackedScene = load("res://GameScenes/tutorial.tscn")


func _on_survival_spawn_tutorial() -> void:
	var instance = scene.instantiate()
	instance.tutorial_finished.connect(carry_signal)
	add_child(instance)


#Just carry the signal upward toward survival.gd for processing
func carry_signal():
	tutorial_finished.emit()
