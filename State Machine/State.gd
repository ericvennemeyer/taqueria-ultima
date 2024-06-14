class_name State
extends Node

signal interrupt_state(new_state: State) 

@export var can_move: bool = true

var character: CharacterBody2D
var animation_player: AnimationPlayer
var next_state: State


func state_process(delta):
	pass


func state_input(event: InputEvent):
	pass


func state_on_animation_finished(anim_name: String):
	pass


func on_enter(prev_state: State):
	pass


func on_exit():
	pass
