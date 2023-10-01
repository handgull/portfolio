extends Node

const SPAWN_RADIUS = 350
@onready var timer = $Timer
@export var bug_enemy_scene: PackedScene
@export var arena_time_manager: Node
var base_spawn_time = 0
var enemy_table = WeightedTable.new()

func _ready():
	enemy_table.add_item(bug_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(_on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)

func _get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	if player == null:
		return Vector2.ZERO
		
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_position = player.global_position + random_direction * SPAWN_RADIUS

		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		if result.is_empty():
			return spawn_position
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	return Vector2.ZERO

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	if player == null:
		return
	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group(Constants.ENTITIES_GROUP)
	if entities_layer == null:
		return
	var spawn_position = _get_spawn_position()
	if spawn_position != Vector2.ZERO:
		entities_layer.add_child(enemy)
		enemy.global_position = _get_spawn_position()

func _on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = .1 / 12 * arena_difficulty
	time_off = min(time_off, .3)
	$Timer.wait_time = base_spawn_time - time_off
