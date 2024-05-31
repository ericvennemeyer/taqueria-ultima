class_name Enemy
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var sprites: Node2D = $Sprites
@export var hurtbox_component: HurtboxComponent

var player
var is_active = true
var is_alive = true

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hurtbox_component.hurt.connect(handle_hurt.unbind(1))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_alive and is_active:
		# Handle jump.
		if (ray_cast_right.is_colliding() or ray_cast_left.is_colliding()) and is_on_floor():
			velocity.y = JUMP_VELOCITY

		if player:
			velocity.x = position.direction_to(player.position).x * SPEED
			if velocity.x > 0.0:
				sprites.scale.x = 1
			elif velocity.x < 0.0:
				sprites.scale.x = -1
			animation_player.play("walk")
		else:
			velocity.x = 0.0
			animation_player.play("idle")

	move_and_slide()


func handle_hurt():
	is_active = false
	if is_alive:
		hurtbox_component.is_invincible = true
		animation_player.play("hurt")


func _on_player_detection_radius_body_entered(body: Node2D) -> void:
	player = body


func _on_player_detection_radius_body_exited(body: Node2D) -> void:
	player = null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		is_active = true
		hurtbox_component.is_invincible = false


func _on_attack_detection_zone_body_entered(body: Node2D) -> void:
	is_active = false
	velocity.x = 0.0
	animation_player.play("attack")


func _on_attack_detection_zone_body_exited(body: Node2D) -> void:
	is_active = true
