extends Node

#Add upgrades here
var Base = Path_Node.new()
var Solar_1 = Path_Node.new()
var Solar_2 = Path_Node.new()

var Base_Dict = {
	"Health": 45,
	"Energy_Required": 1,
	"Label": "Level 1",
	"Upgrade_Price": 200,
	"Recycle_Price": 100,
	"Power_Gen_Time_Sec": 3,
	"EnergyProduce": 4
}

var Solar_1_Dict = {
	"Health": 50,
	"Energy_Required": 1,
	"Label": "Level 2",
	"Upgrade_Price": 300,
	"Recycle_Price": 150,
	"Power_Gen_Time_Sec": 3,
	"EnergyProduce": 9
}

var Solar_2_Dict = {
	"Health": 55,
	"Energy_Required": 1,
	"Label": "Level 3",
	"Upgrade_Price": 400,
	"Recycle_Price": 200,
	"Power_Gen_Time_Sec": 1.5,
	"EnergyProduce": 14
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Base.__init__(
		Base_Dict["Health"],
		Base_Dict["Energy_Required"],
		Base_Dict["Label"],
		Base_Dict["Upgrade_Price"],
		Base_Dict["Recycle_Price"],
		Base_Dict["Power_Gen_Time_Sec"],
		Base_Dict["EnergyProduce"]
	)
	Solar_1.__init__(
		Solar_1_Dict["Health"],
		Solar_1_Dict["Energy_Required"],
		Solar_1_Dict["Label"],
		Solar_1_Dict["Upgrade_Price"],
		Solar_1_Dict["Recycle_Price"],
		Solar_1_Dict["Power_Gen_Time_Sec"],
		Solar_1_Dict["EnergyProduce"]
	)
	Solar_2.__init__(
		Solar_2_Dict["Health"],
		Solar_2_Dict["Energy_Required"],
		Solar_2_Dict["Label"],
		Solar_2_Dict["Upgrade_Price"],
		Solar_2_Dict["Recycle_Price"],
		Solar_2_Dict["Power_Gen_Time_Sec"],
		Solar_2_Dict["EnergyProduce"]
	)

	Base.children.append(Solar_1)
	Solar_1.children.append(Solar_2)

	self.get_parent().current_upgrade_node = Base
