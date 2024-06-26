# Give the component a class name so it can be instanced as a custom node
class_name BorderBounceComponent
extends Node

signal bounce

# The margin is used to allow actors to bounce before reaching the edge of the border
@export var margin: = 8

# Export the actor that this component will operate on
@export var actor: Node2D

# We need to grab the move component of the actor in order to change its velocity when bouncing
#@export var move_component: MoveComponent

# Define the left and right borders to bounce on
var left_border = 0
# Use the display viewport width to get the right border of the screen
var right_border = ProjectSettings.get_setting("display/window/size/viewport_width")
var top_border = 0
var bottom_border = ProjectSettings.get_setting("display/window/size/viewport_height")

func _process(delta: float) -> void:
	# If the actor's x position is less than the left border plus the margin,
	# bounce off the left side of the screen
	if actor.global_position.x < left_border + margin:
		# Prevent the actor for going past the border + the margin
		actor.global_position.x = left_border + margin
		# When bouncing we use the .bounce function which takes a wall normal
		# This wall normal is the direction of the face of the wall
		# (it's a bit counter intuitive but a wall on the left would have a wall face with a normal of RIGHT)
		actor.velocity = actor.velocity.bounce(Vector2.RIGHT)
		bounce.emit()
	# If the actor's x position is greater than the right border plus the margin,
	# bounce off the right side of the screen
	elif actor.global_position.x > right_border - margin:
		# Prevent the actor for going past the border + the margin
		actor.global_position.x = right_border - margin
		# When bouncing we use the .bounce function which takes a wall normal
		# This wall normal is the direction of the face of the wall
		# (it's a bit counter intuitive but a wall on the right would have a wall face with a normal of LEFT)
		actor.velocity = actor.velocity.bounce(Vector2.LEFT)
		bounce.emit()
	elif actor.global_position.y < top_border + margin * 3:
		actor.global_position.y = top_border + margin * 3
		actor.velocity = actor.velocity.bounce(Vector2.DOWN)
	elif actor.global_position.y > bottom_border - margin:
		actor.global_position.y = bottom_border - margin
		actor.velocity = actor.velocity.bounce(Vector2.UP)
