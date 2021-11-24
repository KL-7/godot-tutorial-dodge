extends Node
class_name Stats

signal health_changed(new_health)
signal zero_health

export var max_health: int = 100

onready var health: int = max_health


# Public

func take_damage(damage: int) -> void:
	health = int(max(health - damage, 0))

	emit_signal("health_changed", health)

	if health == 0:
		emit_signal("zero_health")
