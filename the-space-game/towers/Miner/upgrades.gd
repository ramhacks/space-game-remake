extends Node

var Base = Path_Node.new()
var Miner_1 = Path_Node.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Base.__init__(200, 1, "Level 1", 100, 100, 10)
	Miner_1.__init__(200, 10, "Level 2", 100, 100, 15)

	
	Base.children.append(Miner_1)

	
	self.get_parent().current_upgrade_node = Base
