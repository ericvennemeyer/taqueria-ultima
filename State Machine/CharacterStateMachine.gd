class_name CharacterStateMachine
extends Node

@export var character: CharacterBody2D
@export var animation_tree: AnimationTree
@export var current_state: State

var states: Array[State]


func _ready() -> void:
	# Iterate through states and connect references, add to states array
	for child in get_children():
		if child is State:
			states.append(child)
			
			# Additional steps to connect references here
			child.character = character
			child.playback = animation_tree["parameters/playback"]
			
			# Connect interrupt signal from State
			child.interrupt_state.connect(on_state_interrupt_state)
		
		else:
			push_warning("Child " + child.name + " is not a state for CharacterStateMachine")


func _process(delta: float) -> void:
	if current_state.next_state != null:
		switch_states(current_state.next_state)
	
	current_state.state_process(delta)


func check_if_can_move():
	return current_state.can_move


func switch_states(new_state: State):
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	current_state.on_enter()


func _input(event: InputEvent) -> void:
	current_state.state_input(event)


func on_state_interrupt_state(new_state: State):
	switch_states(new_state)
