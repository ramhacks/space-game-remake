extends Node

var Base = Path_Node.new()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Base.__init__(10, 1, "Base", 20, 20)
	self.get_parent().current_upgrade_node = Base
