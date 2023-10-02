extends CanvasLayer

func _ready():
	get_tree().paused = true
	%StartButton.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	get_tree().paused = false
	queue_free()
