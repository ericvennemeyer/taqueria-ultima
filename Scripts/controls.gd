extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		get_tree().change_scene_to_file("res://Scenes/start.tscn")
