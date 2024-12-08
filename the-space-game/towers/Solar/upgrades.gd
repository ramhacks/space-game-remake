extends Node

#Add upgrades here
var Base = Path_Node.new()
var Solar_1 = Path_Node.new()
var Solar_2 = Path_Node.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Health, Energy_Required, Label for upgrade animation, upgrade price, recycle price, damage/special property, range
	Base.__init__(600, 1, "Level 1", 200, 200, 3, 4)
	Solar_1.__init__(800, 1, "Level 2", 200, 300, 2, 9)
	Solar_2.__init__(1000, 1, "Level 3", 200, 400, 1.5, 14)
	
	Base.children.append(Solar_1)
	Solar_1.children.append(Solar_2)
	
	self.get_parent().current_upgrade_node = Base
