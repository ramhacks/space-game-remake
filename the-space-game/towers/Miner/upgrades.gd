extends Node

var Base = Path_Node.new()
var Miner_1 = Path_Node.new()

var Base_Dict = {
	"Health": 45,
	"Energy_Required": 3,
	"Label": "Level 1",
	"Upgrade_Price": 40,
	"Recycle_Price": 30,
	"Custom_Dict": {
		"Resource_Extracted": 10
	},
}

var Miner_1_Dict = {
	"Health": 40,
	"Energy_Required": 5,
	"Label": "Level 2",
	"Upgrade_Price": 200,
	"Recycle_Price": 50,
	"Custom_Dict": {
		"Resource_Extracted": 25
	},
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Custom var 1 is how many minerals to extract on each pass when it gets required power
	Base.__init__(
		Base_Dict["Health"],
		Base_Dict["Energy_Required"],
		Base_Dict["Label"],
		Base_Dict["Upgrade_Price"],
		Base_Dict["Recycle_Price"],
		Base_Dict["Custom_Dict"],
	)

	# bit more energy but much more efficient
	Miner_1.__init__(
		Miner_1_Dict["Health"],
		Miner_1_Dict["Energy_Required"],
		Miner_1_Dict["Label"],
		Miner_1_Dict["Upgrade_Price"],
		Miner_1_Dict["Recycle_Price"],
		Miner_1_Dict["Custom_Dict"],
	)


	Base.children.append(Miner_1)


	self.get_parent().current_upgrade_node = Base
