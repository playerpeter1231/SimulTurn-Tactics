extends Control


# sstates short for Simple_States
enum sstates {
	CHOOSING_CHAR, # For when there is no option chosen
	CHOOSING_PATH, # For when player is choosing character path
	ACCEPTING_PATH, # For when the player is accepting path
	WATCH_PATHS,
}
export(sstates) var curr_state = sstates.CHOOSING_CHAR

onready var all_characters = get_tree().get_nodes_in_group("Characters")
var curr_char = null


func _process(_delta):
	match curr_state:
		sstates.CHOOSING_CHAR:
			if Input.is_action_just_released("click") and curr_char:
				curr_char.init_player_line()
				curr_state = sstates.CHOOSING_PATH
			
			if Input.is_action_just_pressed("open_menu"):
				get_tree().reload_current_scene()

		sstates.CHOOSING_PATH:
			curr_char.draw_player_line()
			
			if curr_char.is_drawing and Input.is_action_just_released("click"):
				curr_char.is_drawing = false
				curr_state = sstates.ACCEPTING_PATH
		
	
		
		sstates.ACCEPTING_PATH:
			$AcceptPathMenu.visible = true
		
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


func handle_choice(character):
	if curr_state == sstates.CHOOSING_CHAR:
		curr_char = character


func _on_Character1_mouse_entered():
	handle_choice($Character1)


func _on_Character2_mouse_entered():
	handle_choice($Character2)


func _on_Character3_mouse_entered():
	handle_choice($Character3)
	

func _on_ChooseChar_button_up():
	curr_char.delete_line()
	curr_char = null
	curr_state = sstates.CHOOSING_CHAR
	$AcceptPathMenu.visible = false


func _on_NewPath_button_up():
	curr_char.init_player_line()
	curr_state = sstates.CHOOSING_PATH
	$AcceptPathMenu.visible = false


func _on_AcceptPath_button_up():
	curr_char.add_to_group("MovingCharacters")
	curr_char = null
	curr_state = sstates.CHOOSING_CHAR
	$AcceptPathMenu.visible = false
	$EndTurn.visible = true


func _on_EndTurnButton_button_up():
	var characters = get_tree().get_nodes_in_group("MovingCharacters")
	for chara in characters:
		chara.init_path()
		curr_state = sstates.WATCH_PATHS
	$EndTurn.visible = false
