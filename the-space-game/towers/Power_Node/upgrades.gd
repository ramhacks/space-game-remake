extends Node

var Base = Path_Node.new()

var Base_Dict = {
	"Health": 10,
	"Energy_Required": 1,
	"Label": "Base",
	"Upgrade_Price": 20,
	"Recycle_Price": 20,
	"Custom_Dict": {
		"Connection_Limit": 5
	},
}

# Called when the node enters the scene tree for the first time.
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
