extends Node

# sstates short for Simple_States
enum sstates {
	NOTHING_PRESSED, # For when there is no option chosen
	CHOOSING_PATH, # For when player is choosing character path
	#ACCEPTING_PATH, # For when the player is accepting path
}
var curr_state = sstates.NOTHING_PRESSED
