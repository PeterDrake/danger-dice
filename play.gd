extends Control

var hexes := {}
var current_hex := [3,3]
var grid_mode := false

signal newly_activated()

const OFFSETS = {'north':[-1, 0], 'northwest':[-1, -1], 'northeast':[0, 1],
				 'south':[1,  0], 'southwest':[0,  -1], 'southeast':[1, 1]}

func _ready() -> void:
	hexes = {
		[1,1]:$Grid/Hex1_1, [1,2]:$Grid/Hex1_2, [1,3]:$Grid/Hex1_3,
		[2,1]:$Grid/Hex2_1, [2,2]:$Grid/Hex2_2, [2,3]:$Grid/Hex2_3, [2,4]:$Grid/Hex2_4,
		[3,1]:$Grid/Hex3_1, [3,2]:$Grid/Hex3_2, [3,3]:$Grid/Hex3_3, [3,4]:$Grid/Hex3_4, [3,5]:$Grid/Hex3_5,
		[4,2]:$Grid/Hex4_2, [4,3]:$Grid/Hex4_3, [4,4]:$Grid/Hex4_4, [4,5]:$Grid/Hex4_5,
		[5,3]:$Grid/Hex5_3, [5,4]:$Grid/Hex5_4, [5,5]:$Grid/Hex5_5}
	for pair in hexes:
		hexes[pair].button_down.connect(_on_hex_button_down.bind(pair))
		hexes[pair].focus_entered.connect(_on_hex_focus_entered)
		hexes[pair].newly_activated.connect(_on_hex_newly_activated)
	hexes[[3,3]].set_current(true)

func _process(_delta: float) -> void:
	if grid_mode:
		for direction in OFFSETS:
			if Input.is_action_just_pressed(direction):
				_navigate(direction)
			if Input.is_action_just_pressed("activate") and not hexes[current_hex]._activated:
				_activate_current_hex()

func _navigate(direction):
	var destination = [current_hex[0] + OFFSETS[direction][0], current_hex[1] + OFFSETS[direction][1]]
	if destination in hexes:
		hexes[current_hex].set_current(false)
		current_hex = destination
		hexes[current_hex].grab_focus.call_deferred()
		hexes[current_hex].set_current(true)

func _activate_current_hex():
	hexes[current_hex].set_activated(true)

func _on_hex_button_down(pair: Array) -> void:
	hexes[current_hex].set_current(false)
	current_hex = pair
	hexes[pair].set_current(true)
	if not hexes[current_hex]._activated:
		hexes[pair].set_activated(true)

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
	
func _on_hex_newly_activated():
	emit_signal("newly_activated")

func _on_roll_dice_button_pressed() -> void:
	$Die1.roll()
	$Die2.roll()
	$Die3.roll()
