extends Line2D

signal mouse_entered()

# Max length path may be
export var max_length = 15
# How long to wait before adding new point to reduce cpu load
export var step_length = 10
var line_length = 0
var first_pos
var last_point = Vector2(0,0)
var is_hovered = false


export(Color) var clicked_color
export(Color) var released_color
export(Color) var curr_color = "00ffffff"
var radius
export var cursor_radius = 8
export var cursor_size = 3
var is_active = false
var is_drawing = false

export(NodePath) var path2d_node_location = "Character"
onready var path_node = get_node(path2d_node_location)
export(NodePath) var followpath_node_location = "Character/PathFollow2D"
onready var follow_node = get_node(followpath_node_location)
export(float) var char_speed = 150


func init_player_line():
	curr_color = clicked_color
	is_active = true
	update()
	
#	Initiate line
	first_pos = get_global_position()
	#print("last point @ init_player_line(), ", last_point)
	add_point(last_point)
	
	#$Cursor.position = last_point
	#$Character.position = last_point
	#print("Cursor location @ init_player_line() ", $Cursor.position)
	#print("Character location @ init_player_line() ", $Character.position)
	line_length = 0
	
	if path_node.curve:
		path_node.curve = Curve2D.new()


func init_path():
	var curve2d = Curve2D.new()
	follow_node.unit_offset = 0
	follow_node.offset = 0
	
	for i in points.size():
		#print("Adding, ", points[i])
		curve2d.add_point(points[i])
	
	path_node.curve = curve2d
	add_to_group("MovingCharacters")


# Calculates points to draw char path and updates the draw function
func draw_player_line():
	
	if Input.is_action_just_pressed("click") and is_hovered:
		is_drawing = true
	
	if is_drawing and Input.is_action_pressed("click"):
		calc_line()
		update()
	
	if is_drawing and Input.is_action_just_released("click"):
		curr_color = released_color
		update()
		#curr_state = sstates.ACCEPTING_PATH
		

func calc_line():
	#print("Currently calculating")
	var relative_pos = get_global_mouse_position() - first_pos
	# Check if mouse has moved so it doesn't add unnessecary points
	if get_global_mouse_position()-first_pos != last_point:
		
		# Create line_length for checks in DragLine and DrawRange
		
		# print("position 0 ", get_point_position(0))
		# print("last point, ", last_point)
		#print("point size, ", get_point_count())
		#print("last point, ",get_point_position(get_point_count()-2))
		#print("This point, ",get_point_position(get_point_count()-1))
		 
		#print("line length, ", line_length)
		if line_length < max_length:
			
			#print("mouse pos, ", get_global_mouse_position())
			#print("Step length, ", get_global_mouse_position().distance_to(last_point))
			if relative_pos.distance_to(last_point) > step_length:
#				var new_point = relative_pos
				add_point(relative_pos)
				$Cursor.set_position(relative_pos)
				line_length += get_point_position(get_point_count()-2).distance_to(relative_pos)
				#print(new_point)
			
				# Set last_point to be called in DrawRange as circle origin
				last_point = relative_pos
				#print("Last point in calc, ", last_point)

# Transition line to showing previous move instead of current
func finish_line():
	if points:
		$LastTurnTrail.points = points
		clear_points()


func delete_line():
	$Cursor.position = last_point
	$Character.position = last_point
	curr_color = "00ffffff"
	

func follow_path(delta):
	if path_node.curve:
		#print("Unit_offset @ moving, ", follow_node.unit_offset)
		if follow_node.unit_offset != 1:
			follow_node.offset += char_speed * delta
		else:
			#print("Character is done moving")
			remove_from_group("MovingCharacters")
		#$Character/PathFollow2D/CharData.position = follow_node.position
	
func _draw():
	if is_active:
		radius = max_length - line_length
		
		# draw_arc( position, radius, start_arc, end_arc, point_count, circ_color, line_width, anti-alias)
		if radius > cursor_radius:
			draw_arc(last_point, radius+4, 0, TAU, 64, curr_color, 4, true)
		draw_arc(last_point, cursor_radius, 0, TAU, 32, "ffffff", cursor_size,true)


func _on_Cursor_mouse_entered():
	print("Emitting signal from line2d")
	is_hovered = true
	emit_signal("mouse_entered")


func _on_Cursor_mouse_exited():
	print("Cursor is false")
	is_hovered = false
