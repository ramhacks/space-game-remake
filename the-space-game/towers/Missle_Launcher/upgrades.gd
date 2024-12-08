extends Node


#Damage is located in the upgarde node
#Add upgrades here
var Missile_1 = Path_Node.new()
var Missile_2 = Path_Node.new()
var Missile_3 = Path_Node.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#Health, Energy_Required, Label for upgrade animation, upgrade price, recycle price, damage/special property, range

	Missile_1.__init__(500, 5, "Level 1", 400, 400, 450, 200)
	Missile_2.__init__(520, 10, "Level 2", 500, 500, 500, 240)
	Missile_3.__init__(540, 17, "Level 3", 1000, 650, 550, 288)
	
	
	
	Missile_1.children.append(Missile_2)
	Missile_2.children.append(Missile_3)
	
	
	
	self.get_parent().current_upgrade_node = Missile_1
