extends Node2D

@export var initial_state: State


var reset_ = false
var current_state : State
var states : Dictionary = {}
var parent_node: Tower
var laser_line: Line2D


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		current_state = initial_state

	
func _process(delta) -> void:
	if current_state:
		current_state.Update(delta)
	
	
	
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())

	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state


func _on_laser_tower_built() -> void:
	if current_state:
		current_state.do_process(parent_node)
