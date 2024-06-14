class_name CharacterStateMachine
extends Node

@export var character: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var current_state: State

var states: Array[State]


func _ready() -> void:
	# Connect animation fnished signal from AnimationPlayer
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	
	# Iterate through states and connect references, add to states array
	for child in get_children():
		if child is State:
			states.append(child)
			
			# Additional steps to connect references here
			child.character = character
			child.animation_player = animation_player
			
			# Connect interrupt signal from State
			child.interrupt_state.connect(on_state_interrupt_state)
		
		else:
			push_warning("Child " + child.name + " is not a state for CharacterStateMachine")


func _physics_process(delta: float) -> void:
	if current_state.next_state != null:
		switch_states(current_state.next_state)
	
	current_state.state_physics_process(delta)


func check_if_can_move():
	return current_state.can_move


func switch_states(new_state: State):
	var prev_state: State
	
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
	
	prev_state = current_state
	current_state = new_state
	current_state.on_enter(prev_state)


func _input(event: InputEvent) -> void:
	current_state.state_input(event)


func _on_animation_player_animation_finished(anim_name: String):
	current_state.state_on_animation_finished(anim_name)


func on_state_interrupt_state(new_state: State):
	switch_states(new_state)
