extends Control
#Edits screen text to display current minerals and current energy the player has

var skip_frame = 0 #only update the energy amount bar every 5 frames so it doesn't give anyone a seizure

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(skip_frame == 2):
		# print(Globals.total_capacity)
		if (Globals.total_capacity < Globals.total_current):

			$Energy_Amount_Bar.max_value = Globals.total_current
			$Energy_Amount_Bar.value = Globals.total_current
		else:
			$Energy_Amount_Bar.max_value = Globals.total_capacity
			$Energy_Amount_Bar.value = Globals.total_current
		skip_frame = 0
	$ResourceContainer/Resources.text = str(Globals.resources)
	$EnergyContainer/Energy.text = str(Globals.total_current)
	#Add a way to calculate resources per minute

	skip_frame +=1


#Highlighting signal recievers
func _on_hot_bar_layer_de_highlight_energy_bar() -> void:
	$EnergyHighlight.hide()

func _on_hot_bar_layer_highlight_mineral_bar() -> void:
	$MineralHighlight.show()


func _on_hot_bar_layer_highlight_energy_bar() -> void:
	$EnergyHighlight.show()

func _on_hot_bar_layer_de_highlight_mineral_bar() -> void:
	$MineralHighlight.hide()
