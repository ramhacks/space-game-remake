extends Node


var Missile_1_Dict = {
	"Health": 40,
	"Energy_Required": 5,
	"Label": "Level 1",
	"Upgrade_Price": 400,
	"Recycle_Price": 300,
	"Custom_Dict": {
		"Damage": 15,
		"Range": 200
	},
}

var Missile_2_Dict = {
	"Health": 50,
	"Energy_Required": 10,
	"Label": "Level 2",
	"Upgrade_Price": 500,
	"Recycle_Price": 400,
	"Custom_Dict": {
		"Damage": 20,
		"Range": 240
	},
}

var Missile_3_Dict = {
	"Health": 60,
	"Energy_Required": 17,
	"Label": "Level 3",
	"Upgrade_Price": 1000,
	"Recycle_Price": 650,
	"Custom_Dict": {
		"Damage": 25,
		"Range": 280
	},
}

#Damage is located in the upgarde node
#Add upgrades here
var Missile_1 = Path_Node.new()
var Missile_2 = Path_Node.new()
var Missile_3 = Path_Node.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#Health, Energy_Required, Label for upgrade animation, upgrade price, recycle price, damage/special property, range

	Missile_1.__init__(
		Missile_1_Dict["Health"],
		Missile_1_Dict["Energy_Required"],
		Missile_1_Dict["Label"],
		Missile_1_Dict["Upgrade_Price"],
		Missile_1_Dict["Recycle_Price"],
		Missile_1_Dict["Custom_Dict"],
	)
	Missile_2.__init__(
		Missile_2_Dict["Health"],
		Missile_2_Dict["Energy_Required"],
		Missile_2_Dict["Label"],
		Missile_2_Dict["Upgrade_Price"],
		Missile_2_Dict["Recycle_Price"],
		Missile_2_Dict["Custom_Dict"],
	)
	Missile_3.__init__(
		Missile_3_Dict["Health"],
		Missile_3_Dict["Energy_Required"],
		Missile_3_Dict["Label"],
		Missile_3_Dict["Upgrade_Price"],
		Missile_3_Dict["Recycle_Price"],
		Missile_3_Dict["Custom_Dict"],
	)



	Missile_1.children.append(Missile_2)
	Missile_2.children.append(Missile_3)



	self.get_parent().current_upgrade_node = Missile_1
