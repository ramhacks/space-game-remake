extends Node


var Base_Dict = {
	"Health": 50,
	"Energy_Required": 30,
	"Label": "Level 1",
	"Upgrade_Price": TowerPrices.Repair,
	"Recycle_Price": 150,
	"Custom_Dict": {
		"Repair Amount": 10,
		"Range": 50,
		"Connection_Limit": 2,
		"Power_Delay": 30
	}

}



var Repair_1 = Path_Node.new()



var dict_path = {
	"Level 1": Repair_1,
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	Repair_1.__init__(
		Base_Dict["Health"],
		Base_Dict["Energy_Required"],
		Base_Dict["Label"],
		Base_Dict["Upgrade_Price"],
		Base_Dict["Recycle_Price"],
		Base_Dict["Custom_Dict"]
	)
#Health, Energy_Required, Label for upgrade animation, upgrade price, recycle price, damage/special property, range


	self.get_parent().current_upgrade_node = Repair_1
