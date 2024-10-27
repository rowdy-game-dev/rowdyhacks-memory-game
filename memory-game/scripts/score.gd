extends Node2D

@onready var score_label = $score_label

var score_count = 0
func _input(event):
	if event.is_action_pressed("add_points"):
		score_count += 1
		score_label.text = "SCORE: %d" % score_count
