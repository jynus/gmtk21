extends AudioStreamPlayer

const max_levels = 20

var current_level = 1
var skip_tutorial = false
var has_music_started = false
var music = false setget turn_music
var song1 = preload("res://music/song_one_2.ogg")
var song2 = preload("res://music/song_two.ogg")

func _ready():
	autoplay = false
	volume_db = -5
	stream = song1


func load_current_level():
	var tutorial_exists = ResourceLoader.exists("res://scenes/level" + str(GlobalVariables.current_level) + "_tutorial.tscn")
	var level_exists = ResourceLoader.exists("res://scenes/level" + str(GlobalVariables.current_level) + ".tscn")
	if tutorial_exists and !skip_tutorial:
		get_tree().change_scene("res://scenes/level" + str(GlobalVariables.current_level) + "_tutorial.tscn")
	elif level_exists:
		get_tree().change_scene("res://scenes/level" + str(GlobalVariables.current_level) + ".tscn")
	else:
		get_tree().change_scene("res://scenes/LevelSelection.tscn")

func turn_music(on):
	if on and !music:
		play()
		print("turning music on")
	elif !on and music:
		stop()
		print("turning music off")
	music = on


func won():
	current_level += 1
