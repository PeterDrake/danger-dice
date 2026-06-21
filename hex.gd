extends TextureButton

const NO_DIE_HERE := 0

var _current: bool
var _activated: bool
var original_normal := load("res://Assets/hex_normal.png")
var original_focused := load("res://Assets/hex_focused.png")
var pressed_focused := load("res://PlaceholderAssets/hex_pressed_focused.png")
var current_face := NO_DIE_HERE

signal newly_activated()

func _ready() -> void:
	var image = texture_normal.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	texture_click_mask = bitmap
	_current = false
	set_activated(false)

func set_activated(value: bool):
	_activated = value
	if value:
		emit_signal("newly_activated")
		texture_normal = texture_pressed
		texture_focused = pressed_focused
	else:
		set_value(NO_DIE_HERE)
		texture_normal = original_normal
		texture_focused = original_focused
	texture_hover = texture_focused

func set_current(value: bool):
	_current = value

func set_value(value: int):
	var danger_names = get_node("../..").danger_names
	current_face = value
	if value == NO_DIE_HERE:
		$Label.text = "Empty"
	else:
		$Label.text = danger_names[value]
