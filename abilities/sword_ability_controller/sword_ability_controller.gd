extends Node

@onready var timer = $Timer
@export var sword_ability: PackedScene

const MAX_RANGE: float = 150.0
var damage = 5
var wait_time: float

func _ready():
	wait_time = $Timer.wait_time
	timer.timeout.connect(_on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)

func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP) as Node2D
	if player == null:
		return
	var enemies = get_tree().get_nodes_in_group(Constants.ENEMIES_GROUP)
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() < 1:
		return
		
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)

	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group(Constants.FOREGROUND_GROUP)
	foreground_layer.add_child(sword_instance)
	sword_instance.hit_box_component.damage = damage
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4

	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()

func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "sword_rate":
		return
	
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
	$Timer.wait_time = wait_time * (1 - percent_reduction)
	$Timer.start()
