extends Area2D

@export var player: Player


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player.on_ladder = true
		#player.set_collision_mask_value(1, false)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player.on_ladder = false
		#player.set_collision_mask_value(1, true)
