extends Sprite2D

@export var sprite_fade_duration: float = 0.5


func _ready() -> void:
	handle_ghosting()

func set_property(tx_pos, tx_scale):
	position = tx_pos
	scale = tx_scale


func handle_ghosting():
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self, "self_modulate", Color(1, 1, 1, 0), sprite_fade_duration)
	await tween_fade.finished
	queue_free()
