extends Node

@export var axe_ability_scene: PackedScene
var damage = 10

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP) as Node2D
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group(Constants.FOREGROUND_GROUP) as Node2D
	if foreground == null:
		return

	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hit_box_component.damage = damage
