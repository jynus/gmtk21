extends Node2D

signal clicked(node)
signal released(node)
signal hovering_on(node)
signal hovering_off(node)

export(Color) var color = Color(1.0, 0.0, 0.0, 1.0)
var hover = false
var removable = false setget set_removable
var connected_from = null
var connected_to = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if color == null:
		color = Color(1.0, 0.0, 0.0, 1.0)
	modulate = color
	connect("clicked", get_node("/root/game"), "on_cable_clicked")
	connect("released", get_node("/root/game"), "on_cable_released")
func _process(delta):
	if hover:
		if Input.is_action_just_pressed("ui_click"):
			print("emiting clicked signal")
			emit_signal("clicked", self)
		if Input.is_action_just_released("ui_click"):
			emit_signal("released", self)

func set_removable(value):
	removable = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func connect_cable(from, to):
	connected_from = from
	from.add_connection(self)
	connected_to = to
	to.add_connection(self)
	removable = true
	#from.connect("output_pin_changed", to, "check_input_change")
	#print("connected with a signal", from.name, " and ", to.name)

func disconnect_cable():
	if connected_from != null:
		connected_from.disconnect("output_pin_changed", connected_to, "check_input_change")
		connected_from.remove_connection(self)
		connected_from = null
	if connected_to != null:
		connected_to.remove_connection(self)
		connected_to = null
	removable = false

func _on_cable_mouse_entered():
	print("hovering over a cable")
	hover = true
	emit_signal("hovering_on", self)

func _on_cable_mouse_exited():
	hover = false
	emit_signal("hovering_off", self)
