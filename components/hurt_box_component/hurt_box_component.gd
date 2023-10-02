extends Area2D
class_name HurtBoxComponent

@export var health_component: HealthComponent
var floating_text_scene = preload("res://ui/floating_text/floating_text.tscn")

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(other_area: Area2D):
	if not other_area is HitBoxComponent:
		return
	if health_component == null:
		return
	
	var hit_box_component = other_area as HitBoxComponent
	health_component.damage(hit_box_component.damage)
	
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position
	floating_text.start(str(hit_box_component.damage))
