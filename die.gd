extends TextureButton

var faces
var pressed_faces
var focused_faces
var pressed_focused_faces
var disabled_focused = load("res://Assets/die_disabled_focused.png")
var current_face
var current_face_danger
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	faces = {
			"Chainsaw":    load("res://Assets/die_normal/die_chainsaw.png"),
			"Clown":       load("res://Assets/die_normal/die_clown.png"),
			"Dentist":     load("res://Assets/die_normal/die_dentist.png"),
			"Lava":        load("res://Assets/die_normal/die_lava.png"),
			"Lightning":   load("res://Assets/die_normal/die_lightning.png"),
			"Quicksand":   load("res://Assets/die_normal/die_quicksand.png"),
			"Rattlesnake": load("res://Assets/die_normal/die_rattlesnake.png"),
			"Shark":       load("res://Assets/die_normal/die_shark.png"),
			"Spider":      load("res://Assets/die_normal/die_spider.png"),
			"Vampire":     load("res://Assets/die_normal/die_vampire.png"),
			"Wasp":        load("res://Assets/die_normal/die_wasp.png"),
			"Wolf":        load("res://Assets/die_normal/die_wasp.png")
	}
	pressed_faces = {
			"Chainsaw":    load("res://Assets/die_selected/die_selected_chainsaw.png"),
			"Clown":       load("res://Assets/die_selected/die_selected_clown.png"),
			"Dentist":     load("res://Assets/die_selected/die_selected_dentist.png"),
			"Lava":        load("res://Assets/die_selected/die_selected_lava.png"),
			"Lightning":   load("res://Assets/die_selected/die_selected_lightning.png"),
			"Quicksand":   load("res://Assets/die_selected/die_selected_quicksand.png"),
			"Rattlesnake": load("res://Assets/die_selected/die_selected_rattlesnake.png"),
			"Shark":       load("res://Assets/die_selected/die_selected_shark.png"),
			"Spider":      load("res://Assets/die_selected/die_selected_spider.png"),
			"Vampire":     load("res://Assets/die_selected/die_selected_vampire.png"),
			"Wasp":        load("res://Assets/die_selected/die_selected_wasp.png"),
			"Wolf":        load("res://Assets/die_selected/die_selected_wolf.png")
	}
	focused_faces = {
			"Chainsaw":    load("res://Assets/die_focused/die_focused_chainsaw.png"),
			"Clown":       load("res://Assets/die_focused/die_focused_clown.png"),
			"Dentist":     load("res://Assets/die_focused/die_focused_dentist.png"),
			"Lava":        load("res://Assets/die_focused/die_focused_lava.png"),
			"Lightning":   load("res://Assets/die_focused/die_focused_lightning.png"),
			"Quicksand":   load("res://Assets/die_focused/die_focused_quicksand.png"),
			"Rattlesnake": load("res://Assets/die_focused/die_focused_rattlesnake.png"),
			"Shark":       load("res://Assets/die_focused/die_focused_shark.png"),
			"Spider":      load("res://Assets/die_focused/die_focused_shark.png"),
			"Vampire":     load("res://Assets/die_focused/die_focused_vampire.png"),
			"Wasp":        load("res://Assets/die_focused/die_focused_wasp.png"),
			"Wolf":        load("res://Assets/die_focused/die_focused_wasp.png")
	}
	pressed_focused_faces = {
			"Chainsaw":    load("res://Assets/die_selected_focused/die_selected_focused_chainsaw.png"),
			"Clown":       load("res://Assets/die_selected_focused/die_selected_focused_clown.png"),
			"Dentist":     load("res://Assets/die_selected_focused/die_selected_focused_dentist.png"),
			"Lava":        load("res://Assets/die_selected_focused/die_selected_focused_lava.png"),
			"Lightning":   load("res://Assets/die_selected_focused/die_selected_focused_lightning.png"),
			"Quicksand":   load("res://Assets/die_selected_focused/die_selected_focused_quicksand.png"),
			"Rattlesnake": load("res://Assets/die_selected_focused/die_selected_focused_rattlesnake.png"),
			"Shark":       load("res://Assets/die_selected_focused/die_selected_focused_shark.png"),
			"Spider":      load("res://Assets/die_selected_focused/die_selected_focused_shark.png"),
			"Vampire":     load("res://Assets/die_selected_focused/die_selected_focused_vampire.png"),
			"Wasp":        load("res://Assets/die_selected_focused/die_selected_focused_wasp.png"),
			"Wolf":        load("res://Assets/die_selected_focused/die_selected_focused_wasp.png")
	}
	roll()
	var image = texture_normal.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	texture_click_mask = bitmap

func roll():
	var danger_names = get_node("..").danger_names
	disabled = false
	current_face = rng.randi_range(1, 6)
	current_face_danger = danger_names[current_face]
	texture_normal = faces[current_face_danger]
	texture_pressed = pressed_faces[current_face_danger]
	texture_focused = focused_faces[current_face_danger]
	texture_hover = texture_focused

func _process(_delta: float) -> void:
	if disabled:
		texture_normal = texture_disabled
		texture_focused = disabled_focused
		accessibility_name = "Die already placed"
	elif button_pressed:
		texture_normal = pressed_faces[current_face_danger]
		texture_focused = pressed_focused_faces[current_face_danger]
		accessibility_name = "Selected die showing " + str(current_face_danger)
	else:
		texture_normal = faces[current_face_danger]
		texture_focused = focused_faces[current_face_danger]
		accessibility_name = "Unselected die showing " + str(current_face_danger)
	texture_hover = texture_focused
