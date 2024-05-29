class_name Player
extends CharacterBody2D

@export var movement_data: PlayerMovementData
@export var is_active = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var air_jump = false
var just_wall_jumped = false
var was_wall_normal = Vector2.ZERO
var on_ladder = false
var is_climbing = false

@onready var selection_indicator: Sprite2D = $SelectionIndicatorSprite
@onready var sprites: Node2D = $Sprites
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var starting_position = global_position

func _physics_process(delta):
	if not on_ladder:
		apply_gravity(delta)
	var input_axis = Input.get_axis("move_left", "move_right")
	var vertical_input_axis = Input.get_axis("climb_down", "climb_up")
	if is_active:
		handle_jump()
		handle_acceleration(input_axis, delta)
		handle_air_acceleration(input_axis, delta)
		handle_climb(vertical_input_axis)
	else:
		input_axis = 0
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
	update_animations(input_axis)


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta


func handle_jump():
	if is_on_floor():
		air_jump = true
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0 or on_ladder:
		if Input.is_action_just_pressed("jump"):
			velocity.y = movement_data.jump_velocity
	elif not is_on_floor() and not on_ladder:
		if Input.is_action_just_released("jump") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2
		
		if Input.is_action_just_pressed("jump") and air_jump:
			velocity.y = movement_data.jump_velocity * 0.8
			air_jump = false


func handle_climb(vertical_input_axis):
	if on_ladder:
		velocity.y = movement_data.climb_velocity * vertical_input_axis
		is_climbing = sign(vertical_input_axis)
	else:
		is_climbing = false


func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.acceleration * delta)


func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.air_acceleration * delta)


func apply_friction(input_axis, delta):
	if input_axis == 0 and (is_on_floor() or on_ladder):
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)


func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)


func update_animations(input_axis):
	if input_axis != 0 and is_active:
		sprites.scale.x = input_axis
		animation_player.play("run")
	elif is_climbing:
		animation_player.play("climb")
	else:
		animation_player.play("idle")
	
	if not is_on_floor() and not is_climbing:
		if not air_jump:
			animation_player.play("double_jump")
		else:
			animation_player.play("jump")

