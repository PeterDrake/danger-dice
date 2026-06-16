extends Control

func _ready() -> void:
	$VBoxContainer/TitleLabel.grab_focus.call_deferred()
