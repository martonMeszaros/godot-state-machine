tool
extends EditorPlugin


func _enter_tree() -> void:
	var gui: Control = get_editor_interface().get_base_control()
	var icon: Texture = gui.get_icon("Node", "EditorIcons")
	add_custom_type("State", "Node", preload("res://addons/state_machine/state.gd"), icon)
	add_custom_type("StateMachine", "Node", preload("res://addons/state_machine/state_machine.gd"), icon)


func _exit_tree() -> void:
	remove_custom_type("State")
	remove_custom_type("StateMachine")
