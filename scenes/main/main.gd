extends Node2D

@export var end_screen_scene: PackedScene
@export var start_screen_scene: PackedScene

func _ready():
	%Player.health_component.died.connect(_on_player_died)
	var start_screen_instance = start_screen_scene.instantiate()
	add_child(start_screen_instance)

func _on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
