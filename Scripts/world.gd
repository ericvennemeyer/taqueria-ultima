extends Node2D

var player_characters_array: Array[Node]
var current_player


@onready var player_controlled: Node = $"Player-Controlled"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	
	player_characters_array = player_controlled.get_children()
	for player: Player in player_characters_array:
		if player.is_active:
			current_player = player
			current_player.selection_indicator.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_player"):
		change_player_character()


func change_player_character():
	var next_player_index
	var current_player_index = player_characters_array.find(current_player)
	if current_player_index != -1:
		next_player_index = current_player_index + 1
		if next_player_index > player_characters_array.size() - 1:
			next_player_index = 0
	print(current_player_index)
	print(next_player_index)
	current_player = player_characters_array[next_player_index]
	for player: Player in player_characters_array:
		player.is_active = false
		player.selection_indicator.visible = false
	current_player.is_active = true
	current_player.selection_indicator.visible = true
