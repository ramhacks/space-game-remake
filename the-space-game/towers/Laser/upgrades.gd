extends Node


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
	Base.__init__(40, 3, "Laser", 100, 50, 30, 60)

	Thel_1.__init__(50, 5, "Thel", 500, 350, 1, 133)
	Thel_2.__init__(60, 10, "Thel 2", 800, 400, 5, 193)
	Thel_3.__init__(70, 17, "Thel 3", 1000, 500, 10, 260)

	Pulsar_1.__init__(50, 2, "Pulsar", 100, 70, 12, 73)
	Pulsar_2.__init__(55, 5, "Pulsar 2", 150, 100, 14, 76)
	Pulsar_3.__init__(60, 7, "Pulsar 3", 300, 200, 16, 86)


	Base.add_child_path(Thel_1)
	Base.add_child_path(Pulsar_1)


	Thel_1.add_child_path(Thel_2)
	Thel_2.add_child_path(Thel_3)

	Pulsar_1.add_child_path(Pulsar_2)
	Pulsar_2.add_child_path(Pulsar_3)


	self.get_parent().current_upgrade_node = Base
