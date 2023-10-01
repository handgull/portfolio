extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar = $MarginContainer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar.value = 0
	(experience_manager as ExperienceManager).experience_updated.connect(_on_experience_updated)

func _on_experience_updated(current_experience: float, target_experience: float):
	if target_experience == 0:
		return
		
	var percent = current_experience / target_experience
	progress_bar.value = percent
