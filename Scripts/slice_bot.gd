class_name SliceBot
extends CharacterBody2D

@export var movement_data: PlayerMovementData
@export var dash_ghost_image: PackedScene
@export var is_active = false
@export var dash_scale: float = 4.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false
var fire_rate_countdown = 0.0

@onready var selection_indicator: Sprite2D = $SelectionIndicatorSprite
@onready var sprites: Node2D = $Sprites
@onready var sprite_2d: Sprite2D = $Sprites/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ghost_timer: Timer = $GhostTimer


func _ready() -> void:
	ghost_timer.timeout.connect(add_ghost_image)
	print(sprite_2d.position)


func _physics_process(delta):
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
	update_animations(input_axis)


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta


func handle_attack(delta):
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		
		velocity.x = movement_data.speed * dash_scale * sprites.scale.x
	else:
		is_attacking = false


func add_ghost_image():
	var ghost_image = dash_ghost_image.instantiate()
	ghost_image.set_property(position + sprite_2d.position, sprite_2d.scale)
	get_tree().current_scene.add_child(ghost_image)


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
