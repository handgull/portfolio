extends Node

signal arena_difficulty_increased(arena_difficulty: int)

@export var end_screen_scene: PackedScene
@onready var timer = $Timer
const DIFFICULTY_INTERVAL = 5
var arena_difficulty = 0

func _process(_delta):
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)
