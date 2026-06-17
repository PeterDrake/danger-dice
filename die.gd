extends TextureButton

var faces
func _ready() -> void:
	faces = {1: load("res://PlaceholderAssets/die_1.png"), 2: load("res://PlaceholderAssets/die_2.png"),
			 3: load("res://PlaceholderAssets/die_3.png"), 4: load("res://PlaceholderAssets/die_4.png"),
			 5: load("res://PlaceholderAssets/die_5.png"), 6: load("res://PlaceholderAssets/die_5.png")}
	var rng = RandomNumberGenerator.new()
	texture_normal = faces[randi_range(1, 6)]
	var image = texture_normal.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	texture_click_mask = bitmap

func _process(_delta: float) -> void:
	pass

func _on_pressed() -> void:
	pass
