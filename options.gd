# Based on https://shaggydev.com/2023/05/22/volume-sliders/

extends Control

var _bus_index: int

var default_dangers := []

var dangers := []

var _danger_count := 6

func _ready() -> void:
	_bus_index = AudioServer.get_bus_index("Master")
	var slider = $HBoxContainer/VBoxContainerRight/VBoxContainerVolume/VolumeSlider
	slider.value_changed.connect(_on_value_changed)
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(_bus_index))
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
	for checkbox in dangers:
		checkbox.toggled.connect(_on_danger_checkbox_toggled)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(value))

func _on_default_danger_button_pressed() -> void:
	for checkbox in dangers:
		checkbox.button_pressed = checkbox in default_dangers
	$HBoxContainer/VBoxContainerRight/ReturnButton.disabled = false

func _on_danger_checkbox_toggled(state: bool):
	if state:
		_danger_count += 1
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
