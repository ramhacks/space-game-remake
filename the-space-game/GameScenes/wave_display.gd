extends Control

var initial_enemy_count = 0;
var wave_in_progress = false
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


func _on_enemy_wave_spawner_wave_start(int: Variant) -> void:
	show()
	wave_in_progress = true
	print("DEBUG VALUES")
	initial_enemy_count = get_tree().get_nodes_in_group("Enemies").size()
	print(initial_enemy_count)
	$WaveProgress.max_value = initial_enemy_count
	print($WaveProgress.max_value)
	$WaveProgress.value = initial_enemy_count
	print($WaveProgress.value)
	print("__________________")
