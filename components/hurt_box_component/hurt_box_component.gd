extends Area2D
class_name HurtBoxComponent

@export var health_component: HealthComponent

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(other_area: Area2D):
	if not other_area is HitBoxComponent:
		return
	if health_component == null:
		return
	
	var hit_box_component = other_area as HitBoxComponent
	health_component.damage(hit_box_component.damage)
