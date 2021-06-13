extends Node2D


func _process(delta):
	set_fullscreen()
	set_music()

func set_fullscreen():
	if OS.window_fullscreen:
		$FullScreen.text = "Fullscreen on"
		$FullScreen.pressed = true
	else:
		$FullScreen.text = "Fullscreen off"
		$FullScreen.pressed = false

func set_music():
	if GlobalVariables.music:
		$Music.text = "Music on"
		$Music.pressed = true
	else:
		$Music.text = "Music off"
		$Music.pressed = false

func _on_FullScreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	set_fullscreen()


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_Music_toggled(button_pressed):
	GlobalVariables.turn_music(button_pressed)
	set_music()
