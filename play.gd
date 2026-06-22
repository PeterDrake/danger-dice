extends Control

var hexes := {}
var dice := {}
var current_hex := [3,3]
var grid_mode := false
var current_die_index := 1
var undo_stack := []
var score: int
var danger_names := {1:"Chainsaw", 2:"Clown", 3:"Lava", 4:"Lightning", 5:"Rattlesnake", 6:"Shark"}
var voices := DisplayServer.tts_get_voices_for_language("en")
var voice_id := voices[40]
var game_over: bool
var sound_invalid_action = load("res://Audio/invalid_action.mp3")

var roll_dice_sound = load("res://Audio/reroll_dice.mp3")
const NO_DIE_HERE := 0

const OFFSETS = {'north':[-1, 0], 'northwest':[-1, -1], 'northeast':[0, 1],
				 'south':[1,  0], 'southwest':[0,  -1], 'southeast':[1, 1]}

func _ready() -> void:
	hexes = {
		[1,1]:$Grid/Hex1_1, [1,2]:$Grid/Hex1_2, [1,3]:$Grid/Hex1_3,
		[2,1]:$Grid/Hex2_1, [2,2]:$Grid/Hex2_2, [2,3]:$Grid/Hex2_3, [2,4]:$Grid/Hex2_4,
		[3,1]:$Grid/Hex3_1, [3,2]:$Grid/Hex3_2, [3,3]:$Grid/Hex3_3, [3,4]:$Grid/Hex3_4, [3,5]:$Grid/Hex3_5,
		[4,2]:$Grid/Hex4_2, [4,3]:$Grid/Hex4_3, [4,4]:$Grid/Hex4_4, [4,5]:$Grid/Hex4_5,
		[5,3]:$Grid/Hex5_3, [5,4]:$Grid/Hex5_4, [5,5]:$Grid/Hex5_5
	}
	dice = {
		1: $Die1,
		2: $Die2,
		3: $Die3
	}
	for pair in hexes:
		hexes[pair].pressed.connect(_on_hex_pressed.bind(pair))
		hexes[pair].focus_entered.connect(_on_hex_focus_entered)
		hexes[pair].accessibility_description = "Row " + str(pair[0]) + " column " + str(pair[1])
	for die in dice:
		dice[die].pressed.connect(_on_die_button_pressed.bind(dice[die]))
	
func reset_game():
	game_over = false
	for pair in hexes:
		hexes[pair].set_activated(false)
	hexes[[3,3]].set_current(true)
	_on_roll_dice_button_pressed()
	hexes[[3, 3]].set_value(NO_DIE_HERE)
	for die in dice.values():
		die.disabled = false
	score = 0
	_on_die_button_pressed($Die1)
	_on_hex_pressed([3, 3])
	_on_roll_dice_button_pressed()
	_clear_undo_stack()
	$VBoxContainer2/UndoButton.disabled = true
	$VBoxContainer2/RollDiceButton.disabled = true

func _process(_delta: float) -> void:
	if visible:
		if grid_mode:
			for direction in OFFSETS:
				if Input.is_action_just_pressed(direction):
					_navigate(direction)
		if not game_over:
			if Input.is_action_just_pressed("undo") and not $VBoxContainer2/UndoButton.disabled:
				_on_undo_button_pressed()
			elif Input.is_action_just_pressed("undo") and $VBoxContainer2/UndoButton.disabled:
				play_invalid_action_sound()
			if Input.is_action_just_pressed("roll_dice") and not $VBoxContainer2/RollDiceButton.disabled:
				_on_roll_dice_button_pressed()
			elif Input.is_action_just_pressed("roll_dice") and $VBoxContainer2/RollDiceButton.disabled:
				play_invalid_action_sound()
			for d in [1, 2, 3]:
				if Input.is_action_just_pressed("die" + str(d)):
					var die = get_node("Die" + str(d))
					_on_die_button_pressed(die)

func _navigate(direction):
	var destination = [current_hex[0] + OFFSETS[direction][0], current_hex[1] + OFFSETS[direction][1]]
	if destination in hexes:
		hexes[current_hex].set_current(false)
		current_hex = destination
		hexes[current_hex].grab_focus.call_deferred()
		hexes[current_hex].set_current(true)
	else:
		play_invalid_action_sound()

func _on_hex_pressed(pair: Array) -> void:
	if not game_over:
		hexes[current_hex].set_current(false)
		current_hex = pair
		hexes[pair].set_current(true)
		if hexes[pair].current_face == NO_DIE_HERE and not dice[current_die_index].disabled:
			undo_stack.push_back([hexes[pair], current_die_index])
			if len(undo_stack) == 3:
				$VBoxContainer2/RollDiceButton.disabled = false
			hexes[pair].set_activated(true)
			dice[current_die_index].disabled = true
			hexes[pair].set_value(dice[current_die_index].current_face)
			if not has_lost(pair):
				$VBoxContainer2/UndoButton.disabled = false
				score += 1
				if score == 19:
					speak("Victory! You placed all 19 dice. Congratulations. To play again, quit to the main menu.")
					end_game()

func has_lost(pair) -> bool:
	for offset in OFFSETS.values():
		var neighbor = pair.duplicate()
		neighbor[0] += offset[0]
		neighbor[1] += offset[1]
		if neighbor in hexes:
			var face = dice[current_die_index].current_face
			if hexes[neighbor].current_face == face:
				speak("You were killed by " + danger_names[face] + ". Your score is " + str(score) + ". To play again, quit to the main menu.")
				end_game()
				return true
	return false

func end_game():
	game_over = true
	$VBoxContainer2/UndoButton.disabled = true
	$VBoxContainer2/RollDiceButton.disabled = true
	for die in dice.values():
		die.disabled = true
	
func speak(text):
	var slider = get_node("../Options/HBoxContainer/VBoxContainerRight/VBoxContainerVolume/VolumeSlider")
	DisplayServer.tts_speak(text, voice_id, slider.value * 100)
	
func _clear_undo_stack():
	undo_stack = []
	$VBoxContainer2/UndoButton.disabled = true

func _on_hex_focus_entered():
	grid_mode = true

func _on_grid_focus_entered():
	grid_mode = false
	_make_center_hex_current()

func _make_center_hex_current():
	for pair in hexes:
		hexes[pair].set_current(false)
	hexes[[3,3]].set_current(true)
	current_hex = [3, 3]

func _on_roll_dice_button_pressed() -> void:
	$AudioStreamPlayer.stream = roll_dice_sound
	$AudioStreamPlayer.play()
	_clear_undo_stack()
	$VBoxContainer2/RollDiceButton.disabled = true
	for die in [$Die1, $Die2, $Die3]:
		die.roll()

func _on_die_button_pressed(selected):
	for die in dice:
		if dice[die] == selected:
			if score > 0:  # This method is also used to place the center die
				if dice[die].disabled:
					speak("The die in slot " + str(die) + " has already been placed")
				else:
					speak("You selected a " + danger_names[dice[die].current_face])
			dice[die].button_pressed = true
			current_die_index = die
		else:
			dice[die].button_pressed = false

func _on_undo_button_pressed() -> void:
	speak("Undo")
	var pair = undo_stack.pop_back()
	var hex = pair[0]
	var index = pair[1]
	dice[index].disabled = false
	hex.set_activated(false)
	hex.set_value(NO_DIE_HERE)
	$VBoxContainer2/RollDiceButton.disabled = true
	score -= 1
	if not undo_stack:
		$VBoxContainer2/UndoButton.disabled = true

func update_dangers():
	for hex in hexes.values():
		hex.set_value(hex.current_face)  # To update name on label

func play_invalid_action_sound():
	$AudioStreamPlayer.stream = sound_invalid_action
	$AudioStreamPlayer.play()
