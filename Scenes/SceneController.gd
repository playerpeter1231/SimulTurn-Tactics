extends Control


# sstates short for Simple_States
enum sstates {
	NOTHING_PRESSED, # For when there is no option chosen
	CHOOSING_PATH, # For when player is choosing character path
	ACCEPTING_PATH, # For when the player is accepting path
}
var curr_state = sstates.NOTHING_PRESSED

var curr_char

func _process(_delta):
	match curr_state:
		sstates.NOTHING_PRESSED:
			if Input.is_action_just_released("click"):
				if curr_char:
					print("Curr character, ",curr_char.name)
			
			if Input.is_action_just_pressed("open_menu"):
				#print("Changing state to choosing path")
				
				$Character1.init_path()
				curr_state = sstates.CHOOSING_PATH
		
		sstates.CHOOSING_PATH:
			
			$Character1.draw_path()
			
			if $Character1.is_drawing and Input.is_action_just_released("click"):
				$Character1.is_drawing = false
				curr_state = sstates.ACCEPTING_PATH
				
			if Input.is_action_just_pressed("open_menu"):
				get_tree().reload_current_scene()
		
		sstates.ACCEPTING_PATH:
			$AcceptPathMenu.visible = true


func handle_choice(character):
	if curr_state == sstates.NOTHING_PRESSED:
		curr_char = character


func _on_Character1_mouse_entered():
	print("You found me! 1")
	print(self.name)
	handle_choice(self)


func _on_Character2_mouse_entered():
	handle_choice(self)


func _on_Character3_mouse_entered():
	handle_choice(self)
	

func _on_ChooseChar_button_up():
	pass # Replace with function body.


func _on_NewPath_button_up():
	$Character1.init_path()
	curr_state = sstates.CHOOSING_PATH
	$AcceptPathMenu.visible = false


func _on_AcceptPath_button_up():
	pass # Replace with function body.


