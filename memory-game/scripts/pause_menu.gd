extends Control


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pass

func pause_menu():
	pass

func _on_resume_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
