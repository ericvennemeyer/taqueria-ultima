class_name TankBot
extends CharacterBody2D

@export var movement_data: PlayerMovementData
@export var is_active = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false
var fire_rate_countdown = 0.0

var is_alive = true

@onready var selection_indicator: Sprite2D = $SelectionIndicatorSprite
@onready var sprites: Node2D = $Sprites
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spawner_component: SpawnerComponent = $Sprites/SpawnerComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var explosion_spawner: SpawnerComponent = $ExplosionSpawner


func _ready() -> void:
	hurtbox_component.hurt.connect(handle_hurt.unbind(1))


func _physics_process(delta):
	if not is_alive: return
	
	fire_rate_countdown -= delta
	apply_gravity(delta)
	var input_axis = Input.get_axis("move_left", "move_right")
	if is_active:
		handle_acceleration(input_axis, delta)
		handle_attack()
	else:
		input_axis = 0
	apply_friction(input_axis, delta)
	move_and_slide()
	if is_active:
		update_animations(input_axis)


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta


func handle_attack():
	if Input.is_action_pressed("attack"):
		is_attacking = true
		if fire_rate_countdown < 0.0:
			fire_rate_countdown = movement_data.fire_rate
			fire_bullet()
			position.x -= movement_data.knockback_amount * sprites.scale.x
	else:
		is_attacking = false


func fire_bullet():
	var bullet = spawner_component.spawn()
	bullet.move_component.velocity.x = bullet.move_component.velocity.x * sprites.scale.x


func handle_hurt():
	#is_active = false
	if is_alive:
		#hurtbox_component.is_invincible = true
		animation_player.play("hurt")


func handle_acceleration(input_axis, delta):
	if not is_on_floor() or is_attacking: return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.acceleration * delta)


func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)


func update_animations(input_axis):
	if input_axis != 0 and is_active:
		sprites.scale.x = input_axis
		animation_player.play("walk")
	elif is_attacking:
		animation_player.play("attack")
	else:
		animation_player.play("idle")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		#is_active = true
		hurtbox_component.is_invincible = false
	elif anim_name == "death":
		explosion_spawner.spawn()
		#queue_free()
