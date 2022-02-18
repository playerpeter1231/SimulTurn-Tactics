extends Control


# sstates short for Simple_States
enum sstates {
	NOTHING_PRESSED, # For when there is no option chosen
	CHOOSING_PATH, # For when player is choosing character path
	ACCEPTING_PATH, # For when the player is accepting path
}
var curr_state = sstates.NOTHING_PRESSED

var curr_char = null

func _process(_delta):
	match curr_state:
		sstates.NOTHING_PRESSED:
			if Input.is_action_just_released("click") and curr_char:
				curr_char.init_path()
				curr_state = sstates.CHOOSING_PATH
		
		sstates.CHOOSING_PATH:
			curr_char.draw_path()
			
			if curr_char.is_drawing and Input.is_action_just_released("click"):
				curr_char.is_drawing = false
				curr_state = sstates.ACCEPTING_PATH
				
			if Input.is_action_just_pressed("open_menu"):
				get_tree().reload_current_scene()
		
		sstates.ACCEPTING_PATH:
			$AcceptPathMenu.visible = true


func handle_choice(character):
	if curr_state == sstates.NOTHING_PRESSED:
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
	curr_state = sstates.NOTHING_PRESSED


func _on_NewPath_button_up():
	curr_char.init_path()
	curr_state = sstates.CHOOSING_PATH
	$AcceptPathMenu.visible = false


func _on_AcceptPath_button_up():
	curr_char.keep_line()
	curr_char = null
	curr_state = sstates.NOTHING_PRESSED


