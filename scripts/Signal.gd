extends Node2D


var signal_1 = preload("res://sprites/signal_1.png")
var signal_0 = preload("res://sprites/signal_0.png")
var SignalSprite = preload("res://scenes/SignalSprite.tscn")

export (String) var value = "0000" setget set_value
var color = "0000"

func _ready():
	pass

func set_value(new_value):
	value = new_value[0]
	color = new_value[1]
	draw_signal()

func draw_signal():
	var pos = 1
	for bit in value:
		var sprite = get_node("Sprite" + str(pos))
		if bit == "0":
			sprite.texture = signal_0
		else:
			sprite.texture = signal_1
		sprite.modulate = color
		pos += 1
