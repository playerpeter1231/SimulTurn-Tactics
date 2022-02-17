extends Node2D

export(Color) var clicked_color
export(Color) var released_color
export(Color) var curr_color = "00ffffff"
var radius
var is_moving = false

func _process(_delta):
	if Input.is_action_just_pressed("click"):
		is_moving = true
		curr_color = clicked_color
		print("Should see a circle")
		update()
	
	if Input.is_action_pressed("click"):
		update()
	
	if Input.is_action_just_released("click"):
		curr_color = released_color
		

func _draw():
	print(is_moving)
	if is_moving:
		radius = $Line2D.max_length - $Line2D.line_length
		print(radius)
		print($Line2D.line_length)
		draw_arc($Line2D.last_point, radius, 0, TAU, 64, curr_color, 4, true)
