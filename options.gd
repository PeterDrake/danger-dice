# Based on https://shaggydev.com/2023/05/22/volume-sliders/

extends Control

const bus_name := "Master"

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	var slider = $HBoxContainer/VBoxContainerLeft/VBoxContainerVolume/VolumeSlider
	slider.value_changed.connect(_on_value_changed)
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
