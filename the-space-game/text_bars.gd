extends Control

var tower_data_pull
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#add each cur_name option to customize for each seperate tower type
	if Globals.tower_selection_mode:
		if(tower_data_pull.cur_name == "miner"):
			
			$Label1.text = "Mine Rate:  " + str(tower_data_pull.mpm) + " mpm"
			$Label2.text = "Total Mined: " + str(tower_data_pull.total_mined)
	
		elif(tower_data_pull.cur_name == "solar"):
			$Label1.text = "Energy Rate:  " + str(tower_data_pull.energy)
			$Label2.visible = false
