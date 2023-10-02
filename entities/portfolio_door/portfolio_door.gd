extends Node2D

@onready var area_2d = $Area2D

func _ready():
	area_2d.area_entered.connect(_on_area_entered)

func _on_area_entered(_other_area: Area2D):
	get_tree().change_scene_to_file("res://scenes/portfolio/portfolio.tscn")
