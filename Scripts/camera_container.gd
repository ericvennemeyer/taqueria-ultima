extends Node2D

var shake = 0

# This is the function that activates this component
func tween_shake(shake_amount: float, shake_duration: float):
	# Set the shake to the shake amount (shake is the value used in the process function to
	# shake the node)
	shake = shake_amount
	
	# Create a tween
	var tween = create_tween()
	
	# Tween the shake value from current down to 0 over the shake duration
	tween.tween_property(self, "shake", 0.0, shake_duration).from_current()

func _physics_process(delta: float) -> void:
	# Manipulate the position of the node by the shake amount every physics frame
	# Use randf_range to pick a random x and y value using the shake value
	position = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))

