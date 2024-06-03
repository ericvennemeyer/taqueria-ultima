extends CanvasLayer

@onready var start_button: Button = $CenterContainer/VBoxContainer/StartButton


func _ready() -> void:
	get_tree().paused = false
	RenderingServer.set_default_clear_color(Color.BLACK)
	start_button.grab_focus()
	MenuMusic.play()
	LevelTransition.fade_from_black()


func _on_start_button_pressed() -> void:
	await LevelTransition.fade_to_black()
	MenuMusic.stop()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	await LevelTransition.fade_from_black()


func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/controls.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
