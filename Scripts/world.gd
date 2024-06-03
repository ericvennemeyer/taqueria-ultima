extends Node2D

var player_characters_array: Array[Node]
var current_player
var score: int = 0

@onready var pause_screen: CanvasLayer = $PauseScreen
@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready var camera_container: Node2D = $CameraContainer
@onready var camera_2d: Camera2D = $CameraContainer/Camera2D
@onready var player_controlled: Node = $"Player-Controlled"
@onready var enemies: Node = $Enemies

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.20000000298023, 0.36078432202339, 0.35686275362968))
	LevelTransition.fade_from_black()
	pause_screen.visible = false
	pause_screen.unpause.connect(_on_unpause_game)
	pause_screen.restart.connect(_on_restart_game)
	score_label.text = "Kills: " + str(score)
	
	player_characters_array = player_controlled.get_children()
	for player in player_characters_array:
		player.player_died.connect(_on_player_died.bind())
		if player.is_active:
			current_player = player
			current_player.selection_indicator.visible = true
			camera_2d.position = current_player.global_position
	
	var enemy_spawner_array = enemies.get_children()
	for spawner in enemy_spawner_array:
		spawner.enemy_death.connect(increase_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.position = current_player.global_position
	
	if Input.is_action_just_pressed("change_player"):
		change_player_character()
	elif  Input.is_action_just_pressed("pause"):
		pause_screen.visible = true
		get_tree().paused = true
		pause_screen.resume_button.grab_focus()


func _on_unpause_game():
	pause_screen.visible = false
	get_tree().paused = false


func _on_restart_game():
	pause_screen.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()


func change_player_character():
	var next_player_index
	var current_player_index = player_characters_array.find(current_player)
	if current_player_index != -1:
		next_player_index = current_player_index + 1
		if next_player_index > player_characters_array.size() - 1:
			next_player_index = 0
	current_player = player_characters_array[next_player_index]
	for player in player_characters_array:
		player.is_active = false
		player.selection_indicator.visible = false
	current_player.is_active = true
	current_player.selection_indicator.visible = true


func increase_score():
	score += 1
	ScoreKeeper.score = score
	print(ScoreKeeper.score)
	score_label.text = "Kills: " + str(score)


func _on_player_died(character: String):
	if character == "hero":
		await LevelTransition.fade_to_red()
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		LevelTransition.fade_from_red()
	else:
		#var index
		#for player in player_characters_array:
			#if player.character_type == character:
				#player.selection_indicator.visible = false
				#index = player_characters_array.find(player)
		#player_characters_array.remove_at(index)
		pass


func _on_player_hero_gun_fired() -> void:
	camera_container.tween_shake(10.0, 0.2)


func _on_tank_bot_tankbot_gun_fired() -> void:
	camera_container.tween_shake(20.0, 0.4)
