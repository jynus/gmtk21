extends Node2D


var source_pin = null
var dragging = false
var cable_scene = preload("res://scenes/Cable.tscn")
var current_cable = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if dragging:
		var cable_vector = get_global_mouse_position() - source_pin.position
		current_cable.rotation = cable_vector.angle() + PI/2
		current_cable.scale.y = cable_vector.length()

func add_new_connection(from, to, cable):
	dragging = false
	print("new cable from ", from.name, " to ", to.name)
	# call from, to, etc.

func start_new_cable(from):
	source_pin = from
	dragging = true
	current_cable = cable_scene.instance()
	current_cable.color = from.cable_color
	from.add_child(current_cable)

func remove_cable(cable):
	dragging = false
	cable.queue_free()

func on_pin_clicked(node):
	if dragging:
		if node.source:
			remove_cable(current_cable)
			current_cable = null
		else:
			add_new_connection(source_pin, node, current_cable)
	elif node.source:
		start_new_cable(node)

