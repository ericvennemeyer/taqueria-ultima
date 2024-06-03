extends CanvasLayer

signal unpause
signal restart

@onready var resume_button: Button = $CenterContainer/VBoxContainer/ResumeButton


func _ready() -> void:
	#resume_button.grab_focus()
	pass


func _on_resume_button_pressed() -> void:
	unpause.emit()


func _on_restart_button_pressed() -> void:
	restart.emit()


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
