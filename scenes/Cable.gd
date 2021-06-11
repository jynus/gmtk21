extends Node2D


export(Color) var color = Color(1.0, 0.0, 0.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
