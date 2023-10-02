extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var enemies_collision = $EnemiesCollision
@onready var health_component = $HealthComponent
@onready var damage_interval = $DamageInterval
@onready var health_bar = $HealthBar

const MAX_SPEED: float = 400.0
const ACCELLERATION_SMOOTHING: float = 25.0
var colliding_bodies: int = 0

func _ready():
	enemies_collision.body_entered.connect(_on_body_entered)
	enemies_collision.body_exited.connect(_on_body_exited)
	damage_interval.timeout.connect(_on_damage_interval_timeout)
	health_component.health_changed.connect(_set_health_bar)
	GameEvents.healing_potion_collected.connect(_on_healing_potion_collected)
	_set_health_bar()

func _process(delta):
	var direction = get_direction_vector()
	var target_velocity = direction * MAX_SPEED
	velocity = Vector2.ZERO
	velocity = lerp(velocity, target_velocity, 1 - exp(-delta * ACCELLERATION_SMOOTHING))
	set_velocity(velocity)
	move_and_slide()
	
	if direction.x != 0 || direction.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	var move_sign = sign(direction.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

func get_direction_vector() -> Vector2:
	var x_movement = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_movement = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(x_movement, y_movement).normalized()

func check_deal_damage():
	if colliding_bodies == 0 || !damage_interval.is_stopped():
		return
		
	health_component.damage(1)
	damage_interval.start()

func _set_health_bar():
	health_bar.value = health_component.get_health_percent()

func _on_body_entered(body: Node2D):
	if body.get_name() == get_name():
		return

	colliding_bodies += 1
	check_deal_damage()

func _on_body_exited(_body: Node2D):
	colliding_bodies -= 1

func _on_damage_interval_timeout():
	check_deal_damage()

func _on_healing_potion_collected(value: float):
	health_component.heal(value)
