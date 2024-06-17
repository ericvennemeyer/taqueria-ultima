extends CanvasLayer

signal leave_pause_settings_menu

@onready var audio_settings: CenterContainer = $AudioSettings


func _on_audio_settings_audio_settings_back_button_pressed() -> void:
	leave_pause_settings_menu.emit()
