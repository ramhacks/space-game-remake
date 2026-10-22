extends Control

var initial_enemy_count = 0;
var wave_in_progress = false
signal change_wave_number(wave_number: int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if wave_in_progress:
		$WaveProgress.value = get_tree().get_nodes_in_group("Enemies").size()
		if $WaveProgress.value == 0:
			wave_in_progress = false
	else:
		hide()



func _on_enemy_wave_spawner_wave_start(wavenum: Variant) -> void:
	show()
	change_wave_number.emit(wavenum)
	wave_in_progress = true
	initial_enemy_count = get_tree().get_nodes_in_group("Enemies").size()
	$WaveProgress.max_value = initial_enemy_count

	$WaveProgress.value = initial_enemy_count
