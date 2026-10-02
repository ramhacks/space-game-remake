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
#Health, Energy_Required per blast, Label for upgrade animation, upgrade price, recycle price, damage/special property, range
	Base.__init__(200, 2, "Laser", 100, 10, 30, 60)

	Thel_1.__init__(200, 5, "Thel", 500, 350, 1, 133)
	Thel_2.__init__(200, 10, "Thel 2", 800, 750, 5, 193)
	Thel_3.__init__(200, 17, "Thel 3", 1000, 1250, 10, 260)

	Pulsar_1.__init__(200, 2, "Pulsar", 100, 150, 12, 73)
	Pulsar_2.__init__(200, 5, "Pulsar 2", 150, 225, 14, 76)
	Pulsar_3.__init__(200, 7, "Pulsar 3", 300, 375, 16, 86)



	Base.children.append(Thel_1)
	Base.children.append(Pulsar_1)

	Thel_1.children.append(Thel_2)
	Thel_2.children.append(Thel_3)

	Pulsar_1.children.append(Pulsar_2)
	Pulsar_2.children.append(Pulsar_3)


	self.get_parent().current_upgrade_node = Base
