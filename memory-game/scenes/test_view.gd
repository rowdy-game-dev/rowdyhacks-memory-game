extends Node2D

@onready var pause_menu: Control = $Pause_menu

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		paused_or_unpaused()

func paused_or_unpaused():
	if get_tree().paused == true:
		pause_menu.hide()
		get_tree().paused = false
	
	elif get_tree().paused == false:
		pause_menu.show()
		get_tree().paused = true
