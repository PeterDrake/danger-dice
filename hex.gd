extends TextureButton

func _ready() -> void:
	var image = texture_normal.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	texture_click_mask = bitmap
