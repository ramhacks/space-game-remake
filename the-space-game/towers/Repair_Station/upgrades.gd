extends Node


var Base_Dict = {
	"Health": 50,
	"Energy_Required": 30,
	"Label": "Level 1",
	"Upgrade_Price": 300,
	"Recycle_Price": 300,
	"Repair_Amount": 5,
	"Range": 150,
	"Cooldown": 30
}

var Repair_1_Dict = {
	"Health": 50,
	"Energy_Required": 40,
	"Label": "Level 2",
	"Upgrade_Price": 300,
	"Recycle_Price": 150,
	"Repair_Amount": 10,
	"Range": 250,
	"Cooldown": 30
}

var Repair_1 = Path_Node.new()
var Repair_2 = Path_Node.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	Repair_1.__init__(
		Base_Dict["Health"],
		Base_Dict["Energy_Required"],
		Base_Dict["Label"],
		Base_Dict["Upgrade_Price"],
		Base_Dict["Recycle_Price"],
		Base_Dict["Repair_Amount"],
		Base_Dict["Range"],
		Base_Dict["Cooldown"]
	)
#Health, Energy_Required, Label for upgrade animation, upgrade price, recycle price, damage/special property, range

	Repair_2.__init__(
		Repair_1_Dict["Health"],
		Repair_1_Dict["Energy_Required"],
		Repair_1_Dict["Label"],
		Repair_1_Dict["Upgrade_Price"],
		Repair_1_Dict["Recycle_Price"],
		Repair_1_Dict["Repair_Amount"],
		Repair_1_Dict["Range"],
		Repair_1_Dict["Cooldown"]
	)


	Repair_1.children.append(Repair_2)
	self.get_parent().current_upgrade_node = Repair_1
