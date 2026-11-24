extends CanvasLayer

signal tutorial_finished()
signal disable_pause()



#Highlighting signals, some dont need them as they highlight the object
# by directly accessing a reference of it
signal highlight_minimap()
signal de_highlight_minimap()

signal highlight_energy_bar()
signal de_highlight_energy_bar()

signal highlight_mineral_bar()
signal de_highlight_mineral_bar



#Only exists to spawn the tutorial scene
var scene: PackedScene = load("res://GameScenes/tutorial.tscn")
@onready var enemy_tower_warning = preload("res://UI Scenes/enemytoweralert.tscn")
const PositionIndexs = preload("res://enums/tutorial_enums.gd").SequenceButtonPositions


#When we recieve a spawn tutorial signal, connect all appropiate signals accordingly.
# The most important one is tutorial_step as that will coordinate highlighting nodes for each
# tutorial step
func _on_survival_spawn_tutorial() -> void:
	var instance = scene.instantiate()
	instance.tutorial_finished.connect(carry_signal)
	instance.tutorial_step.connect(tutorial_highlight_manager)
	disable_pause.emit()
	add_child(instance)


#Just carry the signal upward toward survival.gd for processing
# Also dehighlight all nodes
func carry_signal():
	tutorial_finished.emit()
	de_highlight_minimap.emit()
	var first_solar_node = get_tree().get_nodes_in_group("tower_node")[0]
	first_solar_node.hide_highlight()




func _on_enemy_wave_spawner_show_tower_warning() -> void:
	var warning_sign = enemy_tower_warning.instatiate()
	self.add_child(warning_sign)


#This manages what to highlight for each step of the tutorial
func tutorial_highlight_manager(tutorial_step: PositionIndexs) -> void:
	match tutorial_step:
		PositionIndexs.MINIMAP:
			highlight_minimap.emit()

			var first_solar_node = get_tree().get_nodes_in_group("tower_node")[0]
			first_solar_node.hide_highlight()
		PositionIndexs.SOLAR:
			#To get the solar node we are abusing the fact that there will be only one
			# tower spawned at the beginning and it will be the solar node that
			# survival.gd spawns to start the player off with. Because we know this we know that
			# that solar node is the only one in the tower_node group
			de_highlight_minimap.emit()

			var first_solar_node = get_tree().get_nodes_in_group("tower_node")[0]
			first_solar_node.show_highlight()

			de_highlight_energy_bar.emit()
		PositionIndexs.ENERGY:
			var first_solar_node = get_tree().get_nodes_in_group("tower_node")[0]
			first_solar_node.hide_highlight()

			highlight_energy_bar.emit()

		PositionIndexs.TOWERS:
			de_highlight_energy_bar.emit()

			de_highlight_mineral_bar.emit()
		PositionIndexs.MINERALS:
			highlight_mineral_bar.emit()
		PositionIndexs.ENEMIES:
			de_highlight_mineral_bar.emit()
		PositionIndexs.GOODLUCK:
			pass
