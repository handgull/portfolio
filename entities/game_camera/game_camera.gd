extends Camera2D

var _target_position = Vector2.ZERO

func _ready():
	make_current()

func _process(delta):
	acquire_target()
	global_position = lerp(global_position, _target_position, 1.0 - exp(-delta * 20))

func acquire_target() -> void:
	var player_nodes = get_tree().get_nodes_in_group(Constants.PLAYER_GROUP)
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		_target_position = player.global_position
