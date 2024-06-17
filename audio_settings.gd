extends CenterContainer

signal audio_settings_back_button_pressed

@onready var back_button: Button = $VBoxContainer/BackButton


func _ready() -> void:
	back_button.grab_focus()


func _on_back_button_pressed() -> void:
	audio_settings_back_button_pressed.emit()
