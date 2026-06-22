# Based on https://shaggydev.com/2023/05/22/volume-sliders/

extends Control

var _bus_index: int
var _music_bus_index: int
var default_dangers := []
var dangers := []
var _danger_count := 6
var danger_sounds := {}
var pressed_sound := load("res://Audio/pressed.mp3")

func _ready() -> void:
	_bus_index = AudioServer.get_bus_index("Sfx/Tts")
	var slider = $HBoxContainer/VBoxContainerRight/VBoxContainerVolume/VolumeSlider
	slider.value_changed.connect(_on_value_changed)
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(_bus_index))
	_music_bus_index = AudioServer.get_bus_index("Music")
	var slider2 = $HBoxContainer/VBoxContainerRight/VBoxContainerVolume/MusicVolumeSlider
	slider2.value_changed.connect(_on_music_volume_slider_value_changed)
	slider2.value = db_to_linear(AudioServer.get_bus_volume_db(_music_bus_index))
	default_dangers = [
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerLeft/CheckBox3,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerLeft/CheckBox5,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerLeft/CheckBox6,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerLeft/CheckBox12,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerRight/CheckBox,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerRight/CheckBox7
	]
	dangers = [
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerLeft/CheckBox3,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerLeft/CheckBox5,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerLeft/CheckBox10,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerLeft/CheckBox6,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerLeft/CheckBox12,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerLeft/CheckBox4,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerRight/CheckBox,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerRight/CheckBox7,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerRight/CheckBox2,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerRight/CheckBox11,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerRight/CheckBox8,
		$HBoxContainer/VBoxContainerLeft/HBoxContainer/VBoxContainerRight/CheckBox9
	]
	danger_sounds = {
		"Chainsaw":load("res://Audio/chainsaw.mp3"),
		"Clown":load("res://Audio/clown.mp3"),
		"Dentist":load("res://Audio/dentist.mp3"),
		"Lava":load("res://Audio/lava.mp3"),
		"Lightning":load("res://Audio/lightning.mp3"),
		"Quicksand":load("res://Audio/quicksand.mp3"),
		"Rattlesnake":load("res://Audio/rattlesnake.mp3"),
		"Shark":load("res://Audio/shark.mp3"),
		"Spider":load("res://Audio/spider.mp3"),
		"Vampire":load("res://Audio/vampire.mp3"),
		"Wasp":load("res://Audio/wasp.mp3"),
		"Wolf":load("res://Audio/wolf.mp3")
	}
	for checkbox in dangers:
		checkbox.toggled.connect(_on_danger_checkbox_toggled.bind(checkbox))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(value))
	$AudioStreamPlayer.stream = pressed_sound
	$AudioStreamPlayer.play()

func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_music_bus_index, linear_to_db(value))

func _on_default_danger_button_pressed() -> void:
	for checkbox in dangers:
		checkbox.button_pressed = checkbox in default_dangers
	$HBoxContainer/VBoxContainerRight/ReturnButton.disabled = false

func _on_danger_checkbox_toggled(state: bool, checkbox):
	if state:
		_danger_count += 1
		$AudioStreamPlayer.stream = danger_sounds[checkbox.text]
		$AudioStreamPlayer.play()
	else:
		_danger_count -= 1
	$HBoxContainer/VBoxContainerRight/ReturnButton.disabled = (_danger_count != 6)

func update_dangers():
	var danger_names = get_node("../Play").danger_names
	var i = 1
	for d in dangers:
		if d.button_pressed:
			danger_names[i] = d.text
			i += 1
	get_node("../Play").update_dangers()
