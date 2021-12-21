tool
extends Node

const State := preload("state.gd")


signal state_changed(from, to)

export(NodePath) var initial_state: NodePath setget set_initial_state
var _current := ""


func _get_configuration_warning() -> String:
	if initial_state.is_empty():
		return "Without Initial State defined, set_state() must be called manually."
	if not is_a_parent_of(get_node(initial_state)):
		return "Initial State must be a state of this state machine!"
	return ""


func context_ready() -> void:
	"""Call this function to initialize states by giving them access to context, and set initial state."""
	var context: Node = get_parent()
	for state_ in get_children():
		var state := state_ as State
		state.connect("state_finished", self, "set_state")
		state.set_context(context)
	var initial: State = get_node_or_null(initial_state)
	if initial == null:
		return
	if not is_a_parent_of(initial):
		assert(false, "%s must be a state of this state machine!" % initial.name)
		return
	_current = initial.name
	initial.start()
	_set_state_processing(initial, true)


func get_state() -> State:
	return get_node(_current) as State


func set_state(next_state_name: String) -> void:
	if next_state_name == _current:
		return
	var next: State = get_node_or_null(next_state_name)
	if next == null or not is_a_parent_of(next):
		assert(false, "%s must be a state of this state machine!" % next_state_name)
		return
	var current: State = get_node_or_null(_current)
	if current != null:
		_set_state_processing(current, false)
		current.end()
	next.start()
	_set_state_processing(next, true)
	emit_signal("state_changed", _current, next_state_name)
	_current = next.name


func _set_state_processing(state: State, enable: bool) -> void:
	state.set_physics_process(enable)
	state.set_process(enable)
	state.set_process_input(enable)
	state.set_process_unhandled_input(enable)
	state.set_process_unhandled_key_input(enable)


func set_initial_state(new_value: NodePath) -> void:
	initial_state = new_value
	update_configuration_warning()
