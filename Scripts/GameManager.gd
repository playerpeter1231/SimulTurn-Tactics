extends Node


func _process(_delta):
	if Input.is_action_just_pressed("open_menu"):
		get_tree().quit()
