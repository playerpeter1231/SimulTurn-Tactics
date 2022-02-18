extends Node2D

#export(Color) var clicked_color
#export(Color) var released_color
#export(Color) var curr_color = "00ffffff"
#var radius
#var is_active = false
#var is_drawing = false
#
#
#func init_path():
#	curr_color = clicked_color
#	$Line2D.init_line()
#	is_active = true
#	update()
#
## Calculates points to draw char path and updates the draw function
#func draw_path():
#
#	if Input.is_action_just_pressed("click"):
#		is_drawing = true
#
#	if is_drawing and Input.is_action_pressed("click"):
#		$Line2D.calc_line()
#		update()
#
#	if is_drawing and Input.is_action_just_released("click"):
#		curr_color = released_color
#		update()
#		#curr_state = sstates.ACCEPTING_PATH
#
#func accept_path():
#	pass

#func _draw():
#	if is_active:
#		radius = $Line2D.max_length - $Line2D.line_length
#
#		# draw_arc( position, radius, start_arc, end_arc, point_count, circ_color, line_width, anti-alias)
#		if radius > 8:
#			draw_arc($Line2D.last_point, radius, 0, TAU, 64, curr_color, 4, true)
#		draw_arc($Line2D.last_point, 8, 0, TAU, 32, clicked_color,3,true)
