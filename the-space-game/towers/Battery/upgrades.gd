extends Node


var Base = Path_Node.new()

var Battery_1 = Path_Node.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Base.__init__(500, 1, "Level 1", 300, 100, 10)
	Battery_1.__init__(200, 1, "Level 2", 100, 100, 15)

	
	Base.children.append(Battery_1)

	
	self.get_parent().current_upgrade_node = Base
