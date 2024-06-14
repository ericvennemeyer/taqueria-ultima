class_name GroundState
extends State

@export var idle_animation: String = "idle"
@export var idle_attack_animation: String = "idle_attack"
@export var run_animation: String = "run"
@export var run_attack_animation: String = "run_attack"

@export var jump_state: State


func state_physics_process(delta):
	pass


func state_input(event: InputEvent):
	pass


func state_on_animation_finished(anim_name: String):
	pass


func on_enter(prev_state: State):
	animation_player.play(idle_animation)


func on_exit():
	pass
