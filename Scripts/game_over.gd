extends Node2D

@onready var restart_button: Button = $CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/RestartButton
@onready var score_label: Label = $CanvasLayer/CenterContainer/VBoxContainer/ScoreLabel


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	score_label.text = "YOU HELD OUT AGAINST " + str(ScoreKeeper.score) + " ATTACKERS BEFORE LOSING THE TACO STAND"
	restart_button.grab_focus()


func _on_restart_button_pressed() -> void:
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_main_menu_button_pressed() -> void:
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
