extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVariables.music and !GlobalVariables.playing:
		GlobalVariables.stop()
		GlobalVariables.stream = GlobalVariables.song1
		GlobalVariables.play()
	$skipTutorials.pressed = GlobalVariables.skip_tutorial
	
	for b in get_children():
		if b is Button:
			if b.name != "skipTutorials":
				b.connect("pressed", self, "_on_Button_pressed", [b])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed(which):
	GlobalVariables.current_level = int(which.text)
	GlobalVariables.load_current_level()
	print("loading level ", GlobalVariables.current_level)

func _on_CheckBox_toggled(button_pressed):
	GlobalVariables.skip_tutorial = button_pressed


func _on_ExitButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
