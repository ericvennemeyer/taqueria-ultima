extends CanvasLayer

@onready var back_button: Button = $CenterContainer/VBoxContainer/BackButton


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	back_button.grab_focus()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
