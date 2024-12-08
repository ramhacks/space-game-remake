extends Node

var Repair_1 = Path_Node.new()
var Repair_2 = Path_Node.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#Health, Energy_Required, Label for upgrade animation, upgrade price, recycle price, damage/special property, range
	Repair_1.__init__(400, 6, "Level 1", 300, 300, 4, 133)	
	Repair_2.__init__(600, 8, "Level 2", 150, 200, 4, 200)

	
	Repair_1.children.append(Repair_2)
	self.get_parent().current_upgrade_node = Repair_1
