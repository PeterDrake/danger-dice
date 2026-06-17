# Based on https://shaggydev.com/2023/05/22/volume-sliders/

extends Control

var _bus_index: int

var default_dangers := []

var dangers := []

var _danger_count := 6

func _ready() -> void:
	_bus_index = AudioServer.get_bus_index("Master")
	var slider = $HBoxContainer/VBoxContainerLeft/VBoxContainerVolume/VolumeSlider
	slider.value_changed.connect(_on_value_changed)
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(_bus_index))
	default_dangers = [
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerLeft/CheckBox3,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerLeft/CheckBox5,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerLeft/CheckBox6,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerLeft/CheckBox12,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerRight/CheckBox,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerRight/CheckBox7
	]
	dangers = [
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerLeft/CheckBox3,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerLeft/CheckBox5,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerLeft/CheckBox10,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerLeft/CheckBox6,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerLeft/CheckBox12,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerLeft/CheckBox4,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerRight/CheckBox,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerRight/CheckBox7,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerRight/CheckBox2,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerRight/CheckBox11,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerRight/CheckBox8,
		$HBoxContainer/VBoxContainerRight/HBoxContainer/VBoxContainerRight/CheckBox9
	]
	for checkbox in dangers:
		checkbox.toggled.connect(_on_danger_checkbox_toggled)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(value))

func _on_default_danger_button_pressed() -> void:
	for checkbox in dangers:
		checkbox.button_pressed = checkbox in default_dangers
	$HBoxContainer/VBoxContainerLeft/ReturnButton.disabled = false

func _on_danger_checkbox_toggled(state: bool):
	if state:
		_danger_count += 1
	else:
		_danger_count -= 1
	$HBoxContainer/VBoxContainerLeft/ReturnButton.disabled = (_danger_count != 6)
