extends CanvasLayer

signal tutorial_finished()

#Only exists to spawn the tutorial scene
var scene: PackedScene = load("res://GameScenes/tutorial.tscn")
@onready var enemy_tower_warning = preload("res://UI Scenes/enemytoweralert.tscn")


func _on_survival_spawn_tutorial() -> void:
	var instance = scene.instantiate()
	instance.tutorial_finished.connect(carry_signal)
	add_child(instance)


#Just carry the signal upward toward survival.gd for processing
func carry_signal():
	tutorial_finished.emit()




func _on_enemy_wave_spawner_show_tower_warning() -> void:
	var warning_sign = enemy_tower_warning.instatiate()
	self.add_child(warning_sign)
