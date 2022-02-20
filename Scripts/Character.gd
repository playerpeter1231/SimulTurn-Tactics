extends Line2D

signal mouse_entered()
signal mouse_exited()

# Max length path may be
export var max_length = 15
# How long to wait before adding new point to reduce cpu load
export var start_length = 20
#var line_length = 0
var first_pos
var last_point = Vector2(0,0)
var is_hovered = false
export var max_actions = 5
var actions = max_actions

export(Color) var clicked_color
export(Color) var released_color
export(Color) var curs_color
var curr_radius_color = "00ffffff"
var curr_cursor_color = curs_color
#var radius
export var cursor_radius = 8
export var cursor_size = 3
var is_active = false
var is_drawing = false

export(NodePath) var path2d_node_path = "Character"
onready var character = get_node(path2d_node_path)
export(NodePath) var followpath_node_path = "Character/PathFollow2D"
onready var follow_node = get_node(followpath_node_path)
export(NodePath) var cursor_node_path = "Cursor"
onready var cursor = get_node(cursor_node_path)
export(float) var char_speed = 150


func init_player_line():
	curr_radius_color = clicked_color
	curr_cursor_color = curs_color
	
	is_active = true
	update()
	
#	Initiate line
	first_pos = get_global_position()
	print("Initialize first pos", first_pos)
	#print("last point @ init_player_line(), ", last_point)
	add_point(last_point)
	add_point(last_point)
	
	#$Cursor.position = last_point
	#$Character.position = last_point
	#print("Cursor location @ init_player_line() ", $Cursor.position)
	#print("Character location @ init_player_line() ", $Character.position)
	#line_length = 0
	
	if character.curve:
		character.curve = Curve2D.new()


func reinit_player_line():
	curr_radius_color = clicked_color
	curr_cursor_color = curs_color
	
	is_active = true
	update()
	add_point(last_point)


func init_path():
	var curve2d = Curve2D.new()
	follow_node.unit_offset = 0
	follow_node.offset = 0
	
	for i in points.size():
		#print("Adding, ", points[i])
		curve2d.add_point(points[i])
	
	character.curve = curve2d
	add_to_group("MovingCharacters")


# Calculates points to draw char path and updates the draw function
func draw_player_line():
	
	if Input.is_action_just_pressed("click") and is_hovered:
		is_drawing = true
	
	if is_drawing and Input.is_action_pressed("click"):
		calc_line()
		update()
	
	if (is_drawing and Input.is_action_just_released("click")) or (actions < 1):
		curr_radius_color = released_color
		update()
		#curr_state = sstates.ACCEPTING_PATH
		

func calc_line():
	var relative_pos = get_global_mouse_position() - first_pos
	
	#if relative_pos.distance_to(last_point) > start_length:
	set_point_position(get_point_count()-1,relative_pos)
	if cursor:
		cursor.set_position(relative_pos)
	else:
		print("ERROR: No cursor in calc_line")
	
	if relative_pos.distance_to(last_point) > max_length:
		# Extra math clamps new point to circle point
		var cursor_angle = relative_pos.angle_to_point(last_point)
		var cursor_x = last_point.x + (max_length * cos(cursor_angle))
		var cursor_y = last_point.y + (max_length * sin(cursor_angle))
		var new_point = Vector2(cursor_x,cursor_y)
#		print("Max length,", max_length)
#		print("Last point, ", last_point)
#		print("Relative point, ", relative_pos)
#		print("Angle between two points, ", cursor_angle)
#		print("New point, ", new_point, "\n")
		
		set_point_position(get_point_count()-1,new_point)
		if(actions > 1):
			print("actions, ", actions)
			add_point(relative_pos)
		else:
			if cursor:
				cursor.position = new_point
#		print("All values in points", points)
		last_point = new_point
		actions -= 1

# Transition line to showing previous move instead of current
func finish_line():
	if points:
		$LastTurnTrail.points = points
		actions = max_actions
		clear_points()


func delete_line():
	if cursor:
		cursor.position = get_point_position(0)
	
	actions = max_actions
	last_point = get_point_position(0)
	clear_points()


func delete_step():
	actions += 1
	if get_point_count() > 2:
		remove_point(get_point_count() - 1)
		last_point = get_point_position((get_point_count() - 1))
		cursor.position = last_point
	

func follow_path(delta):
	if character.curve:
		#print("Unit_offset @ moving, ", follow_node.unit_offset)
		if follow_node.unit_offset != 1:
			follow_node.offset += char_speed * delta
		else:
			#print("Character is done moving")
			remove_from_group("MovingCharacters")
		#$Character/PathFollow2D/CharData.position = follow_node.position
	
func _draw():
	if is_active:
#		radius = max_length - line_length
		
		# draw_arc( position, radius, start_arc, end_arc, point_count, circ_color, line_width, anti-alias)
		# Draw distance circle
#		if radius > cursor_radius:
		draw_arc(last_point, max_length, 0, TAU, 64, curr_radius_color, 4, true)
		# Draw Cursor
		if cursor:
			draw_arc(cursor.position, cursor_radius, 0, TAU, 32, curr_cursor_color, cursor_size,true)


func _on_Cursor_mouse_entered():
	print("Emitting signal from line2d")
	is_hovered = true
	emit_signal("mouse_entered")


func _on_Cursor_mouse_exited():
	print("Cursor is false")
	is_hovered = false
