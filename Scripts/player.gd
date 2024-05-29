class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var is_active = false

@onready var selection_indicator: Sprite2D = $SelectionIndicatorSprite

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Get the input direction
	var direction := Input.get_axis("move_left", "move_right")
	if not direction:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if is_active:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Handle the movement/deceleration.
		if direction:
			velocity.x = direction * SPEED

	move_and_slide()
