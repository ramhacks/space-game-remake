extends Node

var Base = Path_Node.new()
var Miner_1 = Path_Node.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Custom var 1 is how many minerals to extract on each pass when it gets required power
	Base.__init__(200, 1, "Level 1", 100, 100, 10)

	# bit more energy but much more efficient
	Miner_1.__init__(200, 2, "Level 2", 200, 150, 15)


	Base.children.append(Miner_1)


	self.get_parent().current_upgrade_node = Base
