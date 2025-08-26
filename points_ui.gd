extends Control

@onready var label: Label = $Label

func _ready() -> void:
	ScoreManager.score_changed.connect(_on_score_changed)
	label.text = "0"

func _on_score_changed(new_score: int) -> void:
	label.text = str(new_score)
