extends Control

var _previous_page

func _ready() -> void:
	_on_return_to_menu_button_pressed()
	# Buttons on title page
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerLeft/PlayButton.pressed.connect(_on_play_button_pressed)
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerLeft/HowToPlayButton.pressed.connect(_on_how_to_play_button_pressed.bind($TitlePage))
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerLeft/OptionsButton.pressed.connect(_on_options_button_pressed.bind($TitlePage))
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerRight/AccessibilityButton.pressed.connect(_on_accessibility_button_pressed)
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerRight/CreditsButton.pressed.connect(_on_credits_button_pressed)
	$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerRight/QuitButton.pressed.connect(_on_quit_button_pressed)
	# Buttons on play page
	$Play/VBoxContainer/HowToPlayButton.pressed.connect(_on_how_to_play_button_pressed.bind($Play))
	$Play/VBoxContainer/OptionsButton.pressed.connect(_on_options_button_pressed.bind($Play))
	$Play/VBoxContainer/QuitToMenuButton.pressed.connect(_on_quit_to_menu_button_pressed)
	# Buttons on options page
	$Options/HBoxContainer/VBoxContainerRight/ReturnButton.pressed.connect(_on_options_return_button_pressed)
	# Buttons on accessibility page
	$Accessibility/VBoxContainer/ReturnButton.pressed.connect(_on_return_to_menu_button_pressed)
	# Buttons on credits page
	$Credits/VBoxContainer/ReturnButton.pressed.connect(_on_return_to_menu_button_pressed)
	# Buttons on how to play page
	$HowToPlay/VBoxContainer/ReturnButton.pressed.connect(_on_how_to_play_return_button_pressed)

func _on_play_button_pressed():
	$TitlePage.visible = false
	$Play.visible = true
	$Play/VBoxContainer/HowToPlayButton.grab_focus.call_deferred()
	$Play.reset_game()

func _on_how_to_play_button_pressed(previous_page):
	print("You pressed how to play")
	# This button is on both the Title and Play pages
	previous_page.visible = false
	_previous_page = previous_page
	$HowToPlay.visible = true
	if get_tree().is_accessibility_enabled():
		$HowToPlay/VBoxContainer/PageTitle.grab_focus.call_deferred()
	else:
		$HowToPlay/VBoxContainer/ReturnButton.grab_focus.call_deferred()

func _on_options_button_pressed(previous_page):
	# This button is on both the Title and Play pages
	previous_page.visible = false
	_previous_page = previous_page
	$Options.visible = true
	if get_tree().is_accessibility_enabled():
		$Options/HBoxContainer/VBoxContainerLeft/ChooseDangerLabel.grab_focus.call_deferred()
	else:
		$Options/HBoxContainer/VBoxContainerLeft/DefaultDangerButton.grab_focus.call_deferred()

func _on_accessibility_button_pressed():
	$TitlePage.visible = false
	$Accessibility.visible = true
	if get_tree().is_accessibility_enabled():
		$Accessibility/VBoxContainer/PageTitle.grab_focus.call_deferred()
	else:
		$Accessibility/VBoxContainer/ReturnButton.grab_focus.call_deferred()

func _on_credits_button_pressed():
	$TitlePage.visible = false
	$Credits.visible = true
	if get_tree().is_accessibility_enabled():
		$Credits/VBoxContainer/PageTitle.grab_focus.call_deferred()
	else:
		$Credits/VBoxContainer/ReturnButton.grab_focus.call_deferred()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_quit_to_menu_button_pressed():
	$Play.visible = false
	$TitlePage.visible = true
	if get_tree().is_accessibility_enabled():
		$TitlePage/VBoxContainer/TitleLabel.grab_focus.call_deferred()
	else:
		$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerLeft/PlayButton.grab_focus.call_deferred()

func _on_options_return_button_pressed():
	$Options.visible = false
	_previous_page.visible = true
	if _previous_page == $TitlePage:
		if get_tree().is_accessibility_enabled():
			$TitlePage/VBoxContainer/TitleLabel.grab_focus.call_deferred()
		else:
			$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerLeft/PlayButton.grab_focus.call_deferred()
	else:
		$Play/VBoxContainer/HowToPlayButton.grab_focus.call_deferred()

func _on_return_to_menu_button_pressed():
	# This button is on both the Accessibility and Credits pages
	$Accessibility.visible = false
	$Credits.visible = false
	$TitlePage.visible = true
	if get_tree().is_accessibility_enabled():
		$TitlePage/VBoxContainer/TitleLabel.grab_focus.call_deferred()
	else:
		$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerLeft/PlayButton.grab_focus.call_deferred()


func _on_how_to_play_return_button_pressed():
	$HowToPlay.visible = false
	_previous_page.visible = true
	if _previous_page == $TitlePage:
		if get_tree().is_accessibility_enabled():
			$TitlePage/VBoxContainer/TitleLabel.grab_focus.call_deferred()
		else:
			$TitlePage/VBoxContainer/HBoxContainer/VBoxContainerLeft/PlayButton.grab_focus.call_deferred()
	else:
		$Play/VBoxContainer/HowToPlayButton.grab_focus.call_deferred()
