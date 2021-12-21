State Machine - State Machine skeleton for Godot Engine
=======================================================

The _StateMachine_ and _State_ nodes provide a base for adding state machines to your scenes in [Godot Engine](https://godotengine.org).

# Usage

When creating your scene, add a StateMachine node as a child to your root, and add each state that inherits `res://addons/state_machine/state.gd` as a grandchild.  
Call `context_ready()` on the state machine in your scene root's `ready()` function to initialize each state and set the initial state (if provided).  
Each state should implement their logic in the engine defined `_process()`, `_physics_process()`, `_input()`, `_unhandled_input()` and `_unhandled_key_input()` functions.  
When you want to transition to another state, you can emit the `state_changed` signal from a state with the next state's node name as the argument.

# Example

## Scene Structure

```
Player (KinematicBody2D)
 - StateMachine (StateMachine)
    - Idle (Node / "idle.gd" script)
	- Moving (Node / "moving.gd" script)
```
It is assumed that StateMachine has been provided with `Idle` as the `Initial State` exported `NodePath`.

## Scripts

### player.gd

```
...
const StateMachine := preload("res://addons/state_machine/state_machine.gd")
func _ready() -> void:
	var state_machine := $StateMachine as StateMachine
	state_machine.context_ready()
...
```

### idle.gd

```
extends "res://addons/state_machine/state.gd"


func start() -> void:
	_context.set_idle_animation()


func _unhandled_key_input(_event: InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		emit_signal("state_finished", "Moving")
```

### moving.gd

```
extends "res://addons/state_machine/state.gd"


func start() -> void:
	_context.set_moving_animation()


func _phisics_process(delta: float) -> void:
	_context.move(delta)


func _unhandled_key_input(_event: InputEventKey) -> void:
	if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		emit_signal("state_finished", "Idle")
```
