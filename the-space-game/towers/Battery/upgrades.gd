extends Node


var Base = Path_Node.new()

var Battery_1 = Path_Node.new()


var Base_Dict = {
	"Health": 60,
	"Energy_Required": 1,
	"Label": "Level 1",
	"Upgrade_Price": 300,
	"Recycle_Price": 100,
	"Custom_Dict": {
		"Power_Capacity": 50,
		"Connection_Limit": 2
	}
}

var Battery_1_Dict = {
	"Health": 70,
	"Energy_Required": 1,
	"Label": "Level 1",
	"Upgrade_Price": 400,
	"Recycle_Price": 150,
	"Custom_Dict": {
		"Power_Capacity": 100,
		"Connection_Limit": 2
	}
}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Base.__init__(
		Base_Dict["Health"],
		Base_Dict["Energy_Required"],
		Base_Dict["Label"],
		Base_Dict["Upgrade_Price"],
		Base_Dict["Recycle_Price"],
		Base_Dict["Custom_Dict"]
	)
	Battery_1.__init__(
		Battery_1_Dict["Health"],
		Battery_1_Dict["Energy_Required"],
		Battery_1_Dict["Label"],
		Battery_1_Dict["Upgrade_Price"],
		Battery_1_Dict["Recycle_Price"],
		Battery_1_Dict["Custom_Dict"]
	)


	Base.children.append(Battery_1)


	self.get_parent().current_upgrade_node = Base
