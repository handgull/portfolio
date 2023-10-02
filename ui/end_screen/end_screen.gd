extends CanvasLayer

func _ready():
	get_tree().paused = true
	%RestartButton.pressed.connect(_on_restart_button_pressed)
	%PortfolioButton.pressed.connect(_on_portfolio_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)

func set_defeat():
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You lost!"

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_portfolio_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/portfolio/portfolio.tscn")
