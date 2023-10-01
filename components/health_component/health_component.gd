extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float = 10
var current_health

func _ready():
	current_health = max_health

func damage(value: float):
	if value <= 0:
		return
	current_health -= value
	health_changed.emit()
	Callable(_check_death).call_deferred()

func heal(value: float):
	if value <= 0:
		return
	current_health = min(current_health + value, max_health)
	health_changed.emit()

func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)

func _check_death():
	if current_health <= 0:
		died.emit()
		owner.queue_free()
