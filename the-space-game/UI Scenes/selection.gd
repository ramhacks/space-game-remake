extends Control


var show = false
var tower_data_pull
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.tower_selection_mode:
		
		$Side_Buttons/Recycle.text = "Recycle: " + str(tower_data_pull.recycle_price[tower_data_pull.level])
		

		$Health/Label.text = "Health " + str(tower_data_pull.get_node("Health").health_amount)
		
		if(tower_data_pull.get_node("Health").health_amount <= 0):
			$Health/ProgressBar.value = 0
		else:
			if(tower_data_pull.get_node("Health").health_amount == 100):
				$Health/ProgressBar.value = 100
			else:
				$Health/ProgressBar.value = tower_data_pull.get_node("Health").health_amount % 100
		

		if(tower_data_pull.cur_name == 'miner'):
			$Side_Buttons/Custom.text = 'All Miners ON'

	else:
		self.visible = false

func show_selection_nodes(tower):
	tower_data_pull = tower
	Globals.tower_selection_mode = true
	self.visible = true
	$TextBars/Label1.visible = true
	$TextBars/Label2.visible = true
	
	$TextBars.tower_data_pull = tower
	
func check_upgrade_available(upgrade_price):
	if(upgrade_price != -1):
		$Side_Buttons/Upgrade_Button.text = "Upgrade: " + str(upgrade_price)
		$Side_Buttons/Upgrade_Button.visible = true
	else:
		$Side_Buttons/Upgrade_Button.visible = false
	
