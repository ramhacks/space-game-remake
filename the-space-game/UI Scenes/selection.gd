extends Control


var show = false
var tower_data_pull
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if Globals.tower_selection_mode and is_instance_valid(tower_data_pull):

		$Side_Buttons/Recycle.text = "Recycle: " + str(tower_data_pull.current_upgrade_node.recycle_price)

		var healthnode = tower_data_pull.get_node("Health")
		$Health/Label.text = "Health " + str(healthnode.health_amount)

		#var to_ratio = ((healthnode.health_amount) / (healthnode.max_health) ) * 100
		#print(to_ratio, "  ", healthnode.health_amount)
		var to_ratio = healthnode.health_amount
		if(to_ratio <= 0):
			$Health/ProgressBar.value = 0
		else:
			if(to_ratio == 100):
				$Health/ProgressBar.value = 100
			else:
				$Health/ProgressBar.value = tower_data_pull.get_node("Health").health_amount % 100


	else:
		self.visible = false

func show_selection_nodes(tower):

	tower_data_pull = tower
	Globals.tower_selection_mode = true
	$TextBars.modify_text(tower)
	self.visible = true
	$TextBars/Label1.visible = true
	$TextBars/Label2.visible = true

	$TextBars.tower_data_pull = tower
