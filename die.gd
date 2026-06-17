extends TextureButton

var faces
var pressed_faces
var current_face
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	faces = {1: load("res://PlaceholderAssets/die_1.png"), 2: load("res://PlaceholderAssets/die_2.png"),
			 3: load("res://PlaceholderAssets/die_3.png"), 4: load("res://PlaceholderAssets/die_4.png"),
			 5: load("res://PlaceholderAssets/die_5.png"), 6: load("res://PlaceholderAssets/die_6.png")}
	pressed_faces = {1: load("res://PlaceholderAssets/die_pressed_1.png"), 2: load("res://PlaceholderAssets/die_pressed_2.png"),
					 3: load("res://PlaceholderAssets/die_pressed_3.png"), 4: load("res://PlaceholderAssets/die_pressed_4.png"),
					 5: load("res://PlaceholderAssets/die_pressed_5.png"), 6: load("res://PlaceholderAssets/die_pressed_6.png")}
	roll()
	var image = texture_normal.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	texture_click_mask = bitmap

func _process(_delta: float) -> void:
	pass

func _on_pressed() -> void:
	print(name + " pressed")

func roll():
	current_face = rng.randi_range(1, 6)
	texture_normal = faces[current_face]
	texture_pressed = pressed_faces[current_face]
