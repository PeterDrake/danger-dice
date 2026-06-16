extends Control

func _ready() -> void:
	# Buttons on title page
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerLeft/PlayButton.pressed.connect(_on_play_button_pressed)
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerLeft/HowToPlayButton.pressed.connect(_on_how_to_play_button_pressed)
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerLeft/OptionsButton.pressed.connect(_on_options_button_pressed)
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerRight/AccessibilityButton.pressed.connect(_on_accessibility_button_pressed)
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerRight/CreditsButton.pressed.connect(_on_credits_button_pressed)
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerRight/QuitButton.pressed.connect(_on_quit_button_pressed)
	# Buttons on play page
	$Play/VBoxContainer/HowToPlayButton.pressed.connect(_on_how_to_play_button_pressed)
	$Play/VBoxContainer/OptionsButton.pressed.connect(_on_options_button_pressed)
	$Play/VBoxContainer/QuitToMenuButton.pressed.connect(_on_quit_to_menu_button_pressed)

func _on_play_button_pressed():
	$TitlePage.visible = false
	$Play.visible = true

func _on_how_to_play_button_pressed():
	$TitlePage.visible = false
	$Play.visible = false
	$HowToPlay.visible = true

func _on_options_button_pressed():
	$TitlePage.visible = false
	$Play.visible = false
	$Options.visible = true

func _on_accessibility_button_pressed():
	$TitlePage.visible = false
	$Accessibility.visible = true

func _on_credits_button_pressed():
	$TitlePage.visible = false
	$Credits.visible = true

func _on_quit_button_pressed():
	get_tree().quit()

func _on_quit_to_menu_button_pressed():
	$Play.visible = false
	$TitlePage.visible = true
