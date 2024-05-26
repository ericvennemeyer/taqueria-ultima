class_name Enemy
extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var player

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if (ray_cast_right.is_colliding() or ray_cast_left.is_colliding()) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if player:
		velocity.x = position.direction_to(player.position).x * SPEED
	else:
		velocity.x = 0.0

	move_and_slide()


func _on_player_detection_radius_body_entered(body: Node2D) -> void:
	print("body entered")
	player = body


func _on_player_detection_radius_body_exited(body: Node2D) -> void:
	print("body exited")
	player = null
