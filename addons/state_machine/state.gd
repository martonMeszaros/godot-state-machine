extends Node


signal state_finished(new_state_name)

var _context


func _init() -> void:
	set_physics_process(false)
	set_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)


func set_context(p_context: Node) -> void:
	"""Overwrite this in derived types if you want to store context as a typed member."""
	_context = p_context


func start() -> void:
	pass


func end() -> void:
	pass
