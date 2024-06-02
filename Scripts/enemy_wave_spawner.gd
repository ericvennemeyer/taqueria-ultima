extends Node2D

signal enemy_death

@export var enemy_run_direction = 1

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var wave_start_delay_timer: Timer = $WaveStartDelayTimer
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer


func _on_wave_start_delay_timer_timeout() -> void:
	enemy_spawn_timer.start()


func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy()


func spawn_enemy():
	var new_enemy = spawner_component.spawn()
	new_enemy.enemy_death.connect(_on_enemy_death)
	new_enemy.run_direction = enemy_run_direction


func _on_enemy_death():
	enemy_death.emit()
