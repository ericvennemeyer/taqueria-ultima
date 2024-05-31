class_name DroneBot
extends CharacterBody2D

@export var movement_data: PlayerMovementData
@export var is_active = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false
var fire_rate_countdown = 0.0

@onready var selection_indicator: Sprite2D = $SelectionIndicatorSprite
@onready var sprites: Node2D = $Sprites
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var attack_duration_timer: Timer = $AttackDurationTimer


func _ready() -> void:
	attack_duration_timer.timeout.connect(stop_attack)


func _physics_process(delta):
	fire_rate_countdown -= delta
	var input_axis = Input.get_axis("move_left", "move_right")
	var vertical_input_axis = Input.get_axis("climb_down", "climb_up")
	if is_active:
		handle_air_acceleration(input_axis, vertical_input_axis, delta)
		handle_attack()
	else:
		input_axis = 0
	apply_air_resistance(input_axis, vertical_input_axis, delta)
	move_and_slide()
	update_animations(input_axis)


func handle_attack():
	if Input.is_action_just_pressed("attack"):
		if fire_rate_countdown < 0.0:
			is_attacking = true
			hitbox_component.is_active = true
			attack_duration_timer.start()


func stop_attack():
	is_attacking = false
	hitbox_component.is_active = false
	fire_rate_countdown = movement_data.fire_rate


func handle_air_acceleration(input_axis, vertical_input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.air_acceleration * delta)
	if vertical_input_axis != 0:
		velocity.y = move_toward(velocity.y, vertical_input_axis * -movement_data.speed, movement_data.air_acceleration * delta)


func apply_air_resistance(input_axis, vertical_input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)
	if vertical_input_axis == 0:
		velocity.y = move_toward(velocity.y, 0, movement_data.air_resistance * delta)


func update_animations(input_axis):
	if input_axis != 0 and is_active and not is_attacking:
		sprites.scale.x = input_axis
		animation_player.play("walk")
	elif is_attacking:
		animation_player.play("attack")
	else:
		animation_player.play("idle")