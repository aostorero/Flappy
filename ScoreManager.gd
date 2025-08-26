extends Node

var score = 0

signal score_changed(new_score)

func add_score() -> void:
	score += 1
	score_changed.emit(score)
