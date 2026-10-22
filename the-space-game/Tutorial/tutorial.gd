extends Node

signal disable_pause()
signal enable_pause()
const PositionIndexs = preload("res://enums/tutorial_enums.gd").SequenceButtonPositions
#List of positions (x and y) of each button, sequetially in the tutorial.
# Makes it easy as we can just move the buttons when they are pressed
# Local Space positions, but this doesn't matter as the node the tutorial node
# will just move them itself
var continue_button_positions = [
	Vector2(224.0, 384.0),
	Vector2(848.0, 304.0),
	Vector2(1096.0, 472.0),
	Vector2(1096.0, 472.0),
	Vector2(1096.0, 472.0),
	Vector2(544.0, 256.0),
	Vector2(256.0, 224.0)
];
var back_button_positions = [
	Vector2(0.0, 384.0),
	Vector2(624.0, 304.0),
	Vector2(872.0, 472.0),
	Vector2(872.0, 472.0),
	Vector2(872.0, 472.0),
	Vector2(320.0, 256.0),
	Vector2(32.0, 224.0)
];

var close_button_positions = [
	Vector2(224.0, 264.0),
	Vector2(848.0, 88.0),
	Vector2(1096.0, 256.0),
	Vector2(1096.0, 256.0),
	Vector2(1096.0, 256.0),
	Vector2(544.0, 40.0),
	Vector2(256.0, 8.0)
]

var current_state = PositionIndexs.MINIMAP
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	disable_pause.emit()
	$Continue.position = continue_button_positions[current_state]
	$Back.position = back_button_positions[current_state]
	$Close.position = close_button_positions[current_state]
	$MiniMap.show()
	get_tree().set_pause(true)

	Globals.pause_game()

## When continue is pressed change positions of both buttons accordingly
func _on_continue_pressed() -> void:
	if current_state + 1 < PositionIndexs.size():
		current_state = (current_state + 1) as PositionIndexs
		$Continue.position = continue_button_positions[current_state]
		$Back.position = back_button_positions[current_state]
		$Close.position = close_button_positions[current_state]
		process_state_change()
	else:
		enable_pause.emit()
		get_tree().set_pause(false)
		Globals.restart_game()
		queue_free()


## When back is pressed change position of both buttons accordingly
func _on_back_pressed() -> void:
	if current_state - 1 < 0 :
		return
	else:
		current_state = (current_state - 1) as PositionIndexs
		$Continue.position = continue_button_positions[current_state]
		$Back.position = back_button_positions[current_state]
		$Close.position = close_button_positions[current_state]
		process_state_change()

## Manages displaying each of the tutorial texts
func process_state_change() -> void:
	match current_state:
		PositionIndexs.MINIMAP:
			$MiniMap.show()
			$Enemies.hide()
			$Minerals.hide()
			$Solar.hide()
			$Energy.hide()
			$TowerSelections.hide()
			$GoodLuck.hide()
		PositionIndexs.SOLAR:
			$MiniMap.hide()
			$Enemies.hide()
			$Minerals.hide()
			$Solar.show()
			$TowerSelections.hide()
			$Energy.hide()
			$GoodLuck.hide()
		PositionIndexs.ENERGY:
			$MiniMap.hide()
			$Enemies.hide()
			$TowerSelections.hide()
			$Minerals.hide()
			$Solar.hide()
			$Energy.show()
			$GoodLuck.hide()
		PositionIndexs.TOWERS:
			$MiniMap.hide()
			$Enemies.hide()
			$TowerSelections.show()
			$Minerals.hide()
			$Solar.hide()
			$Energy.hide()
			$GoodLuck.hide()
		PositionIndexs.MINERALS:
			$MiniMap.hide()
			$Enemies.hide()
			$TowerSelections.hide()
			$Minerals.show()
			$Solar.hide()
			$Energy.hide()
			$GoodLuck.hide()
		PositionIndexs.ENEMIES:
			$MiniMap.hide()
			$Enemies.show()
			$TowerSelections.hide()
			$Minerals.hide()
			$Solar.hide()
			$Energy.hide()
			$GoodLuck.hide()
		PositionIndexs.GOODLUCK:
			$MiniMap.hide()
			$Enemies.hide()
			$Minerals.hide()
			$TowerSelections.hide()
			$Solar.hide()
			$Energy.hide()
			$GoodLuck.show()

#Exit tutorial
func _on_close_pressed() -> void:
	enable_pause.emit()
	get_tree().set_pause(false)
	Globals.restart_game()
	queue_free()
