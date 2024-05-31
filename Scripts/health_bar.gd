extends TextureProgressBar

@export var stats_component: StatsComponent


func _ready() -> void:
	max_value = stats_component.health
	value = stats_component.health
	stats_component.health_changed.connect(update_health_display.bind())


func update_health_display(new_health):
	value = new_health
