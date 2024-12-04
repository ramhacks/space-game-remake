extends Node2D

@export var initial_state: State


var reset_ = false
var current_state : State
var states : Dictionary = {}
var target_node: Tower
var target_changed = false





func start_ai():
	target_node = self.get_parent().get_new_target()
	initial_state.Enter()
	current_state = initial_state
	
	
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)

	
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


func _on_chase_transitioned(state: Variant, new_state_name: Variant) -> void:
	pass # Replace with function body.


func _on_surround_transitioned(state: Variant, new_state_name: Variant) -> void:
	pass # Replace with function body.
