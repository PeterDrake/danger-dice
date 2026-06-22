extends TextureButton

const NO_DIE_HERE := 0

var _current: bool
var _activated: bool
var original_normal := load("res://Assets/hex_normal.png")
var original_focused := load("res://Assets/hex_focused.png")
var pressed_unfocused := {}
var pressed_focused := {}
var current_face := NO_DIE_HERE

func _ready() -> void:
	pressed_focused = {
		"Chainsaw":    load("res://Assets/hex_pressed_focused/hex_pressed_focused_chainsaw.png"),
		"Clown":       load("res://Assets/hex_pressed_focused/hex_pressed_focused_clown.png"),
		"Dentist":     load("res://Assets/hex_pressed_focused/hex_pressed_focused_dentist.png"),
		"Lava":        load("res://Assets/hex_pressed_focused/hex_pressed_focused_lava.png"),
		"Lightning":   load("res://Assets/hex_pressed_focused/hex_pressed_focused_lightning.png"),
		"Quicksand":   load("res://Assets/hex_pressed_focused/hex_pressed_focused_quicksand.png"),
		"Rattlesnake": load("res://Assets/hex_pressed_focused/hex_pressed_focused_rattlesnake.png"),
		"Shark":       load("res://Assets/hex_pressed_focused/hex_pressed_focused_shark.png"),
		"Spider":      load("res://Assets/hex_pressed_focused/hex_pressed_focused_spider.png"),
		"Vampire":     load("res://Assets/hex_pressed_focused/hex_pressed_focused_vampire.png"),
		"Wasp":        load("res://Assets/hex_pressed_focused/hex_pressed_focused_wasp.png"),
		"Wolf":        load("res://Assets/hex_pressed_focused/hex_pressed_focused_wolf.png")
	}
	pressed_unfocused = {
		"Chainsaw":    load("res://Assets/hex_pressed/hex_pressed_chainsaw.png"),
		"Clown":       load("res://Assets/hex_pressed/hex_pressed_clown.png"),
		"Dentist":     load("res://Assets/hex_pressed/hex_pressed_dentist.png"),
		"Lava":        load("res://Assets/hex_pressed/hex_pressed_lava.png"),
		"Lightning":   load("res://Assets/hex_pressed/hex_pressed_lightning.png"),
		"Quicksand":   load("res://Assets/hex_pressed/hex_pressed_quicksand.png"),
		"Rattlesnake": load("res://Assets/hex_pressed/hex_pressed_rattlesnake.png"),
		"Shark":       load("res://Assets/hex_pressed/hex_pressed_shark.png"),
		"Spider":      load("res://Assets/hex_pressed/hex_pressed_spider.png"),
		"Vampire":     load("res://Assets/hex_pressed/hex_pressed_vampire.png"),
		"Wasp":        load("res://Assets/hex_pressed/hex_pressed_wasp.png"),
		"Wolf":        load("res://Assets/hex_pressed/hex_pressed_wolf.png")
	}
	var image = texture_normal.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	texture_click_mask = bitmap
	_current = false
	set_activated(false)

func set_activated(value: bool):
	_activated = value
	if value:
		pass
	else:
		set_value(NO_DIE_HERE)

func set_current(value: bool):
	_current = value

func set_value(value: int):
	var danger_names = get_node("../..").danger_names
	current_face = value
	if value == NO_DIE_HERE:
		$Label.text = "Empty"
		texture_normal = original_normal
		texture_focused = original_focused
	else:
		if get_node("../..").visible:
			var player = get_node("../../AudioStreamPlayer")
			player.stream = get_node("../../../Options").danger_sounds[danger_names[value]]
			player.play()
		$Label.text = danger_names[value]
		texture_normal = pressed_unfocused[danger_names[value]]
		texture_focused = pressed_focused[danger_names[value]]
	texture_hover = texture_focused
