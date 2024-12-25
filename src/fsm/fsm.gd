class_name FSM
extends Node

var all_states : Dictionary = {}
var curr_state : State
@export var initial_state : State

func _ready() -> void:
	# Get all states in the FSM
	for state in get_children():
		if state is State:
			all_states[state.name.to_lower()] = state
			state.state_transition.connect(transition)
		
	# Enter the initial state
	if initial_state:
		initial_state.enter()
		curr_state = initial_state
	
# Update the current state
func _process(delta: float) -> void:
	if curr_state:
		curr_state.update(delta)
		
func transition(prev_state: State, next_state_name: String) -> void:
	if prev_state != curr_state:
		print("[ERROR: Invalid transition, prev_state != curr_state")
		return
	
	# Get the next state
	var next_state = all_states.get(next_state_name.to_lower())
	if !next_state:
		print("[ERROR]: Invalid transition, next state: {name} 
		does not exist".format({"name": next_state_name.to_lower()}))
		return
		
	# Leave this state and enter next
	if curr_state:
		curr_state.leave()
		
	next_state.enter()
	curr_state = next_state
