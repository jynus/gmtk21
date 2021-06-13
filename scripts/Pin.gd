extends Area2D

signal clicked(node)
signal released(node)
signal hovering_on(node)
signal hovering_off(node)
signal input_pin_changed(node)
#signal output_pin_changed(node)

export (bool) var source = true
export (bool) var gate = false
export (bool) var output_signal = true
export (String) var value = "0000" setget change_value
export (bool) var correct = false setget set_correct

var cable_color = Color(0, 1, 1, 1)
var hover = false
var connections = []
var green_led_sprite = preload("res://sprites/green_led.png")
var red_led_sprite = preload("res://sprites/red_led.png")

func signal_to_color(value):
	match value:
		"0000": return Color(0, 1, 1, 1)
		"0001": return Color(0, 1, 1, 1)
		"0010": return Color(1, 1, 0, 1)
		"0011": return Color(0.5, 1, 0.5, 1)
		"0100": return Color(1, 1, 0, 1)
		"0101": return Color(1, 1, 0, 1)
		"0110": return Color(1, 1, 0, 1)
		"0111": return Color(1, 1, 0, 1)
		"1000": return Color(0, 0, 0, 1)
		"1001": return Color(1, 1, 0, 1)
		"1010": return Color(1, 0, 1, 1)
		"1011": return Color(0.7, 0.2, 0, 1)
		"1100": return Color(0.5, 0.5, 1, 1)
		"1101": return Color(1, 0, 1, 1)
		"1110": return Color(1, 0, 0, 1)
		"1111": return Color(1, 1, 1, 1)

func _ready():
	if output_signal:
		change_value(value)
		$signal.value = [value, cable_color]
		$signal.visible = true
	else:
		$signal.visible = false
	if !source and output_signal:
		$pinLabelAnchor.scale.x = -1
		$signal.scale.x = -1
		$pinLabelAnchor.position.x = -200
		$signal.position.x = -100
		$pinLabelAnchor/pinLabel/ledSprite.visible = true
	connect("clicked", get_node("/root/game"), "on_pin_clicked")
	connect("released", get_node("/root/game"), "on_pin_released")
	connect("hovering_on", get_node("/root/game"), "on_pin_enter_hovering")
	connect("hovering_off", get_node("/root/game"), "on_pin_exit_hovering")

func _process(delta):
	if hover:
		if Input.is_action_just_pressed("ui_click"):
			emit_signal("clicked", self)
		if Input.is_action_just_released("ui_click"):
			emit_signal("released", self)

func check_input_change(other_pin):
	check_correct()
	if connections.size() == 1:
		change_value(connections[0].connected_from.value)
	else:
		change_value("0000")
	#if !source and gate:
	#	emit_signal("output_pin_changed", self)

func change_value(new_value):
	value = new_value
	cable_color = signal_to_color(new_value)
	print(connections)
	for c in connections:
		if c.connected_to != self:
			c.connected_to.change_value(new_value)
	
func set_correct(value):
	correct = value
	if correct:
		$pinLabelAnchor/pinLabel/ledSprite.texture = green_led_sprite
	else:
		$pinLabelAnchor/pinLabel/ledSprite.texture = red_led_sprite

func check_correct():
	set_correct(!source and connections.size() == 1 and connections[0].connected_from.value == value)

func add_connection(cable):
	connections.append(cable)
	print(connections)
	check_correct()
	if !source and gate:
		if connections.size() == 1:
			change_value(connections[0].connected_from.value)
		else:
			change_value("0000")
		emit_signal("input_pin_changed", self)

func remove_connection(cable):
	connections.erase(cable)
	check_correct()
	if !source and gate:
		if connections.size() == 1:
			change_value(connections[0].connected_from.value)
		else:
			change_value("0000")
		emit_signal("input_pin_changed", self)

func _on_pin_mouse_entered():
	hover = true
	emit_signal("hovering_on", self)

func _on_pin_mouse_exited():
	hover = false
	emit_signal("hovering_off", self)
