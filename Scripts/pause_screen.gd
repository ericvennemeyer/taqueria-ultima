extends CanvasLayer

signal unpause
signal restart

@onready var resume_button: Button = $CenterContainer/VBoxContainer/ResumeButton
@onready var pause_settings: CanvasLayer = $PauseSettings


func _ready() -> void:
	pause_settings.visible = false
	resume_button.grab_focus()


func _on_resume_button_pressed() -> void:
	unpause.emit()


func _on_restart_button_pressed() -> void:
	restart.emit()


func _on_settings_button_pressed() -> void:
	visible = false
	pause_settings.visible = true


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start.tscn")


func _on_pause_settings_leave_pause_settings_menu() -> void:
	pause_settings.visible = false
	visible = true
