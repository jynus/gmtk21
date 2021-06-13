extends Node2D

func _ready():
	# disable exit application button on html exports
	if OS.get_name() == "HTML5":
		$ExitButton.disabled = true
		$ExitButton.visible = false
	# start music by default, but only once
	if !GlobalVariables.has_music_started:
		GlobalVariables.music = true
		GlobalVariables.has_music_started = true

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/LevelSelection.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_OptionsButton_pressed():
	get_tree().change_scene("res://scenes/Options.tscn")


func _on_Credits_pressed():
	get_tree().change_scene("res://scenes/Credits.tscn")
