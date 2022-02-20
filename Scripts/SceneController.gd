extends Control


# sstates short for Simple_States
enum sstates {
	CHOOSING_CHAR, # For when there is no option chosen
	DRAWING_PATH, # For when player is choosing character path
	ACCEPTING_PATH, # For when the player is accepting path
	WATCH_PATHS,
}
export(sstates) var curr_state = sstates.CHOOSING_CHAR

onready var all_characters = get_tree().get_nodes_in_group("Characters")
var curr_char = null

export(String) var accept_menu_path = "AcceptPathMenu"
onready var accept_menu = get_node(accept_menu_path)
export(String) var end_turn_menu_path = "EndTurn"
onready var end_menu = get_node(end_turn_menu_path)
export(String) var action_menu_path = "ActionMenu"
onready var action_menu = get_node(action_menu_path)


func init_drawing_path():
	if $ActionCount:
		$ActionCount.visible = true


func init_accepting_path():
	if accept_menu:
		accept_menu.visible = true
	else:
		print("ERROR: No accept menu during init_ACCEPTING_PATH")
	
	if action_menu:
#		print("Curr_char position, ", curr_char.position.x)
		if curr_char.position.x > 100:
			action_menu.anchor_left = 0
			action_menu.anchor_right = 0
			action_menu.margin_right = 108
			action_menu.margin_left = 0
		else:
			action_menu.anchor_left = 1
			action_menu.anchor_right = 1
			action_menu.margin_right = 0
			action_menu.margin_left = -108
		
		action_menu.visible = true
	else:
		print("ERROR: No action menu during init_ACCEPTING_PATH")


func leave_accepting_path(state, end_turn):
	#print("Leaving accepting path from within function")
	if accept_menu:
		accept_menu.visible = false
	else:
		print("ERROR: No accept turn menu from leave_accepting_path")
	
	if action_menu:
		action_menu.visible = false
	else:
		print("ERROR: No Action menu during leave accepting path")
	
	if end_menu and end_turn:
		end_menu.visible = true
	else:
		print("ERROR: No end turn menu from leave_accepting_path")
	


	#print("Leaving accepting path to, ", state)
	curr_state = state


func _process(_delta):
	if Input.is_action_just_pressed("open_menu"):
		print("curr_state, ", curr_state)
	
	match curr_state:
		sstates.CHOOSING_CHAR:
			if Input.is_action_just_released("click") and curr_char and curr_char.actions > 0:
				curr_char.init_player_line()
				init_drawing_path()
				curr_state = sstates.DRAWING_PATH
			
#			if Input.is_action_just_pressed("open_menu"):
#				get_tree().reload_current_scene()

		sstates.DRAWING_PATH:
			curr_char.draw_player_line()
			if $ActionCount:
				$ActionCount.text = "Current actions left: " + str(curr_char.actions)
			
			if (curr_char.is_drawing and Input.is_action_just_released("click")) or (curr_char.actions < 1):
				curr_char.is_drawing = false
				init_accepting_path()
				curr_state = sstates.ACCEPTING_PATH
		
		sstates.ACCEPTING_PATH:
#			print("Current char actions, ", curr_char.actions)
#			print("Current char is hovered, ", curr_char.is_hovered)
			if $ActionCount:
				$ActionCount.text = "Current actions left: " + str(curr_char.actions)
			
			if Input.is_action_just_pressed("click") and curr_char.actions > 0 and curr_char.is_hovered:
				print("going from accepting path to choosing path")
				curr_char.reinit_player_line()
				leave_accepting_path(sstates.DRAWING_PATH, false)

		
		sstates.WATCH_PATHS:
			# Bulk of option is in _physics_process
			pass


func _physics_process(delta):
	var characters = get_tree().get_nodes_in_group("MovingCharacters")
	if curr_state == sstates.WATCH_PATHS:
		for chara in characters:
			chara.follow_path(delta)
		
		if not characters:
			print("Resetting chars for next turn")
			reset_chars()
			curr_state = sstates.CHOOSING_CHAR

# Resets characters to have full ranges and new relative positions
func reset_chars():
	for chara in all_characters:
		chara.finish_line()


func handle_enter(character):
	if curr_state == sstates.CHOOSING_CHAR:
		curr_char = character
	
	#if curr_char:
		#print("New curr_char, ",curr_char)


func _on_Character1_mouse_entered():
	handle_enter($Character1)


func _on_Character2_mouse_entered():
	handle_enter($Character2)


func _on_Character3_mouse_entered():
	handle_enter($Character3)


func _on_ChooseChar_button_up():
	curr_char.delete_line()
	curr_char = null
	curr_state = sstates.CHOOSING_CHAR
	if accept_menu:
		accept_menu.visible = false


func _on_NewPath_button_up():
	curr_char.delete_step()


func _on_AcceptPath_button_up():
	curr_char.add_to_group("MovingCharacters")
	curr_char.curr_cursor_color = "00ffffff"
	curr_char.update()
	curr_char = null
	#print("Attempting to leave state from AcceptPath button")
	if $ActionCount:
		$ActionCount.visible = false
	leave_accepting_path(sstates.CHOOSING_CHAR, true)
	

func _on_EndTurnButton_button_up():
	var characters = get_tree().get_nodes_in_group("MovingCharacters")
	for chara in characters:
		chara.init_path()
		curr_state = sstates.WATCH_PATHS
		
	if end_menu:
		end_menu.visible = false
