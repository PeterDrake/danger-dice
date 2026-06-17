extends TextureButton

var faces
var pressed_faces
var focused_faces
var pressed_focused_faces
var disabled_focused = load("res://PlaceholderAssets/die_disabled_focused.png")
var current_face
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	faces = {1: load("res://PlaceholderAssets/die_1.png"), 2: load("res://PlaceholderAssets/die_2.png"),
			 3: load("res://PlaceholderAssets/die_3.png"), 4: load("res://PlaceholderAssets/die_4.png"),
			 5: load("res://PlaceholderAssets/die_5.png"), 6: load("res://PlaceholderAssets/die_6.png")}
	pressed_faces = {1: load("res://PlaceholderAssets/die_pressed_1.png"), 2: load("res://PlaceholderAssets/die_pressed_2.png"),
					 3: load("res://PlaceholderAssets/die_pressed_3.png"), 4: load("res://PlaceholderAssets/die_pressed_4.png"),
					 5: load("res://PlaceholderAssets/die_pressed_5.png"), 6: load("res://PlaceholderAssets/die_pressed_6.png")}
	focused_faces = {1: load("res://PlaceholderAssets/die_focused_1.png"), 2: load("res://PlaceholderAssets/die_focused_2.png"),
					 3: load("res://PlaceholderAssets/die_focused_3.png"), 4: load("res://PlaceholderAssets/die_focused_4.png"),
					 5: load("res://PlaceholderAssets/die_focused_5.png"), 6: load("res://PlaceholderAssets/die_focused_6.png")}
	pressed_focused_faces = {1: load("res://PlaceholderAssets/die_pressed_focused_1.png"), 2: load("res://PlaceholderAssets/die_pressed_focused_2.png"),
							 3: load("res://PlaceholderAssets/die_pressed_focused_3.png"), 4: load("res://PlaceholderAssets/die_pressed_focused_4.png"),
							 5: load("res://PlaceholderAssets/die_pressed_focused_5.png"), 6: load("res://PlaceholderAssets/die_pressed_focused_6.png")}
	roll()
	var image = texture_normal.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	texture_click_mask = bitmap

func roll():
	disabled = false
	current_face = rng.randi_range(1, 6)
	accessibility_name = str(current_face)
	texture_normal = faces[current_face]
	texture_pressed = pressed_faces[current_face]
	texture_focused = focused_faces[current_face]
	texture_hover = texture_focused

func _process(_delta: float) -> void:
	if disabled:
		texture_focused = disabled_focused
	elif button_pressed:
		texture_focused = pressed_focused_faces[current_face]
	else:
		texture_focused = focused_faces[current_face]
	texture_hover = texture_focused
