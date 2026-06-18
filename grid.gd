extends Control

func _ready():
	grab_focus()
	focus_mode = Control.FOCUS_ALL
	accessibility_name = "Hello"

func _notification(what: int) -> void:
	if what == NOTIFICATION_ACCESSIBILITY_UPDATE:
		var ae := get_accessibility_element()
		DisplayServer.accessibility_update_set_role(ae, DisplayServer.ROLE_CELL)
