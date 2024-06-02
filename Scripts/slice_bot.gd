class_name SliceBot
extends CharacterBody2D

signal player_died(character)

@export var movement_data: PlayerMovementData
@export var dash_ghost_image: PackedScene
@export var is_active = false
@export var dash_scale: float = 4.0
@export var dash_duration: float = 0.8

var character_type = "slice_bot"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false
var fire_rate_countdown = 0.0

var is_alive = true

@onready var selection_indicator: Sprite2D = $SelectionIndicatorSprite
@onready var sprites: Node2D = $Sprites
@onready var sprite_2d: Sprite2D = $Sprites/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ghost_timer: Timer = $GhostTimer
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hurtbox_collision_shape: CollisionShape2D = $HurtboxComponent/CollisionShape2D
@onready var explosion_spawner: SpawnerComponent = $ExplosionSpawner
@onready var hitbox_collision_shape: CollisionShape2D = $HitboxComponent/CollisionShape2D
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer


func _ready() -> void:
	hurtbox_component.hurt.connect(handle_hurt.unbind(1))
	ghost_timer.timeout.connect(add_ghost_image)


func _physics_process(delta):
	if not is_alive: return
	
	fire_rate_countdown -= delta
	apply_gravity(delta)
	var input_axis = Input.get_axis("move_left", "move_right")
	if is_active:
		handle_acceleration(input_axis, delta)
		handle_attack(delta)
	else:
		input_axis = 0
	apply_friction(input_axis, delta)
	move_and_slide()
	if is_active:
		update_animations(input_axis)


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta


func handle_attack(delta):
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		ghost_timer.start()
		hitbox_collision_shape.disabled = false
		hurtbox_collision_shape.disabled = true
		var dash_tween = get_tree().create_tween()
		dash_tween.tween_property(self, "position", Vector2(position.x + movement_data.speed * dash_scale * sprites.scale.x, position.y), dash_duration)
		await dash_tween.finished
		ghost_timer.stop()
		hitbox_collision_shape.disabled = true
		hurtbox_collision_shape.disabled = false
		
		is_active = false
		attack_cooldown_timer.start()
		
	else:
		is_attacking = false


func add_ghost_image():
	var ghost_image = dash_ghost_image.instantiate()
	ghost_image.set_property(position + sprite_2d.position, sprite_2d.scale)
	get_tree().current_scene.add_child(ghost_image)


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
		set_collision_layer_value(2, false)
		player_died.emit(character_type)


func _on_attack_cooldown_timer_timeout() -> void:
	is_active = true
