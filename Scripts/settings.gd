extends CanvasLayer

#@onready var back_button: Button = $CenterContainer/VBoxContainer/BackButton
@onready var audio_settings: CenterContainer = $AudioSettings


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)


func _on_audio_settings_audio_settings_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
