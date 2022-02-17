extends Line2D

export var max_length = 15
var line_length = 0
export var first_pos = Vector2(250,250)
var last_point

func _process(_delta):
	if Input.is_action_just_pressed("click"):
		clear_points()
		add_point(first_pos)
		last_point = first_pos
	
	if Input.is_action_pressed("click"):
		if get_global_mouse_position() != get_point_position(get_point_count()-1):
			line_length = get_point_position(0).distance_to(get_global_mouse_position())
			if line_length < max_length:
				add_point(get_global_mouse_position())
				$Sprite.set_position(get_global_mouse_position())
				last_point = get_point_position(get_point_count()-1)
	
