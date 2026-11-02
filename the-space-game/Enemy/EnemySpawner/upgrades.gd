extends Node

var Base= Path_Node.new()

var Base_Dict = {
	"Health": 15,
	"Energy_Required": 1,
	"Label": "NaN",
	"Upgrade_Price": 0,
	"Recycle_Price": 0,
	"Custom_Dict": {
		"Damage": 3,
		"Recharge": 4,
		"Connection_Limit": 0,
		"Power_Delay": 0
	}
}

func _ready() -> void:
	Base.__init__(
		Base_Dict["Health"],
		Base_Dict["Energy_Required"],
		Base_Dict["Label"],
		Base_Dict["Upgrade_Price"],
		Base_Dict["Recycle_Price"],
		Base_Dict["Custom_Dict"],
	)

	self.get_parent().current_upgrade_node = Base
