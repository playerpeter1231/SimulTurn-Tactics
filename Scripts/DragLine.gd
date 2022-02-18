extends Line2D

# Max length path may be
export var max_length = 15
# How long to wait before adding new point to reduce cpu load
export var step_length = 10
var line_length = 0
onready var first_pos = get_global_position()
var last_point


export(Color) var clicked_color
export(Color) var released_color
export(Color) var curr_color = "00ffffff"
var radius
var is_active = false
var is_drawing = false


func init_path():
	curr_color = clicked_color
	
#	$Line2D.init_line()
	clear_points()
	last_point = Vector2(0,0)
	add_point(last_point)
	$Character.position = last_point
	line_length = 0
	
	is_active = true
	update()

# Calculates points to draw char path and updates the draw function
func draw_path():
	
	if Input.is_action_just_pressed("click"):
		is_drawing = true
	
	if is_drawing and Input.is_action_pressed("click"):
		calc_line()
		update()
	
	if is_drawing and Input.is_action_just_released("click"):
		curr_color = released_color
		update()
		#curr_state = sstates.ACCEPTING_PATH

func accept_path():
	pass

#func init_line():
	# Initialize line to draw from original position
#	clear_points()
#	last_point = Vector2(0,0)
#	add_point(last_point)
#	$Sprite.position = last_point
#	line_length = 0
	#print("last point, ", last_point)


func calc_line():
	#print("Currently calculating")
	var relative_pos = get_global_mouse_position() - first_pos
	# Check if mouse has moved so it doesn't add unnessecary points
	if get_global_mouse_position()-first_pos != last_point:
		
		# Create line_length for checks in DragLine and DrawRange
		
		# print("position 0 ", get_point_position(0))
		# print("last point, ", last_point)
		#line_length = get_point_position(0).distance_to(last_point)
		
		#print("point size, ", get_point_count())
		#print("last point, ",get_point_position(get_point_count()-2))
		#print("This point, ",get_point_position(get_point_count()-1))
		#line_length += get_point_position(i-1).distance_to(get_point_position(i)) 
		 
		
		#print("line length, ", line_length)
		if line_length < max_length:
			
			#print("mouse pos, ", get_global_mouse_position())
			#print("Step length, ", get_global_mouse_position().distance_to(last_point))
			if relative_pos.distance_to(last_point) > step_length:
				var new_point = relative_pos
				add_point(new_point)
				$Character.set_position(new_point)
				line_length += get_point_position(get_point_count()-2).distance_to(new_point)
				#print(new_point)
			
				# Set last_point to be called in DrawRange as circle origin
				last_point = new_point

func _draw():
	if is_active:
		var radius = max_length - line_length
		
		# draw_arc( position, radius, start_arc, end_arc, point_count, circ_color, line_width, anti-alias)
		if radius > 8:
			draw_arc(last_point, radius, 0, TAU, 64, "ffffff", 4, true)
		draw_arc(last_point, 8, 0, TAU, 32, "ffffff",3,true)
