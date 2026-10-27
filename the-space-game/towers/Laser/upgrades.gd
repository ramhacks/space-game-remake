extends Node

var Base_Dict = {
	"Health": 40,
	"Energy_Required": 3,
	"Label": "Laser",
	"Upgrade_Price": 100,
	"Recycle_Price": 50,
	"Custom_Dict": {
		"Damage": 10,
		"Range": 60,
		"Power_Delay": 3,
		"Connection_Limit": 2
	}
}

var Thel_1_Dict = {
	"Health": 50,
	"Energy_Required": 5,
	"Label": "Thel",
	"Upgrade_Price": 500,
	"Recycle_Price": 350,
	"Custom_Dict": {
		"Damage": 12,
		"Range": 133,
		"Power_Delay": 5,
		"Connection_Limit": 2
	}
}

var Thel_2_Dict = {
	"Health": 60,
	"Energy_Required": 10,
	"Label": "Thel 2",
	"Upgrade_Price": 800,
	"Recycle_Price": 400,
	"Custom_Dict": {
		"Damage": 15,
		"Range": 193,
		"Power_Delay": 5,
		"Connection_Limit": 2
	}
}

var Thel_3_Dict = {
	"Health": 70,
	"Energy_Required": 17,
	"Label": "Thel 3",
	"Upgrade_Price": 1000,
	"Recycle_Price": 500,
	"Custom_Dict": {
		"Damage": 20,
		"Range": 260,
		"Power_Delay": 5,
		"Connection_Limit": 2
	}
}

var Pulsar_1_Dict = {
	"Health": 45,
	"Energy_Required": 2,
	"Label": "Pulsar",
	"Upgrade_Price": 100,
	"Recycle_Price": 70,
	"Custom_Dict": {
		"Damage": 4,
		"Range": 73,
		"Power_Delay": 2,
		"Connection_Limit": 2
	}
}

var Pulsar_2_Dict = {
	"Health": 50,
	"Energy_Required": 3,
	"Label": "Pulsar 2",
	"Upgrade_Price": 150,
	"Recycle_Price": 100,
	"Custom_Dict": {
		"Damage": 4,
		"Range": 73,
		"Power_Delay": 2,
		"Connection_Limit": 2
	}
}

var Pulsar_3_Dict = {
	"Health": 55,
	"Energy_Required": 5,
	"Label": "Pulsar 2",
	"Upgrade_Price": 300,
	"Recycle_Price": 200,
	"Custom_Dict": {
		"Damage": 8,
		"Range": 85,
		"Power_Delay": 2,
		"Connection_Limit": 2,
	}
}

#Damage is located in the upgarde node
#Add upgrades here

var Base = Path_Node.new()


var Thel_1 = Path_Node.new()
var Thel_2 = Path_Node.new()
var Thel_3 = Path_Node.new()

var Pulsar_1 = Path_Node.new()
var Pulsar_2 = Path_Node.new()
var Pulsar_3 = Path_Node.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Less energy required means it can fire more often
#Health, Energy_Required per blast, Label for upgrade animation, upgrade price, recycle price, damage/special property, range
# power_delay_time
	Base.__init__(
		Base_Dict["Health"],
		Base_Dict["Energy_Required"],
		Base_Dict["Label"],
		Base_Dict["Upgrade_Price"],
		Base_Dict["Recycle_Price"],
		Base_Dict["Custom_Dict"],
	)

	Thel_1.__init__(
		Thel_1_Dict["Health"],
		Thel_1_Dict["Energy_Required"],
		Thel_1_Dict["Label"],
		Thel_1_Dict["Upgrade_Price"],
		Thel_1_Dict["Recycle_Price"],
		Thel_1_Dict["Custom_Dict"],
	)

	Thel_2.__init__(
		Thel_2_Dict["Health"],
		Thel_2_Dict["Energy_Required"],
		Thel_2_Dict["Label"],
		Thel_2_Dict["Upgrade_Price"],
		Thel_2_Dict["Recycle_Price"],
		Thel_2_Dict["Custom_Dict"],
	)

	Thel_3.__init__(
		Thel_3_Dict["Health"],
		Thel_3_Dict["Energy_Required"],
		Thel_3_Dict["Label"],
		Thel_3_Dict["Upgrade_Price"],
		Thel_3_Dict["Recycle_Price"],
		Thel_3_Dict["Custom_Dict"],
	)

	Pulsar_1.__init__(
		Pulsar_1_Dict["Health"],
		Pulsar_1_Dict["Energy_Required"],
		Pulsar_1_Dict["Label"],
		Pulsar_1_Dict["Upgrade_Price"],
		Pulsar_1_Dict["Recycle_Price"],
		Pulsar_1_Dict["Custom_Dict"],
	)
	Pulsar_2.__init__(
		Pulsar_2_Dict["Health"],
		Pulsar_2_Dict["Energy_Required"],
		Pulsar_2_Dict["Label"],
		Pulsar_2_Dict["Upgrade_Price"],
		Pulsar_2_Dict["Recycle_Price"],
		Pulsar_2_Dict["Custom_Dict"],
	)

	Pulsar_3.__init__(
		Pulsar_3_Dict["Health"],
		Pulsar_3_Dict["Energy_Required"],
		Pulsar_3_Dict["Label"],
		Pulsar_3_Dict["Upgrade_Price"],
		Pulsar_3_Dict["Recycle_Price"],
		Pulsar_3_Dict["Custom_Dict"],
	)



	Base.add_child_path(Thel_1)
	Base.add_child_path(Pulsar_1)


	Thel_1.add_child_path(Thel_2)
	Thel_2.add_child_path(Thel_3)

	Pulsar_1.add_child_path(Pulsar_2)
	Pulsar_2.add_child_path(Pulsar_3)


	self.get_parent().current_upgrade_node = Base
