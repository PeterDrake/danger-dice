extends TextureButton

var _current: bool
var _activated: bool
var original_normal := texture_normal
var original_focused := texture_focused

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
		texture_focused = texture_pressed
	else:
		texture_normal = original_normal
		texture_focused = original_focused

func set_current(value: bool):
	_current = value
