extends Area2D

signal clicked(node)
signal released(node)
signal hovering_on(node)
signal hovering_off(node)

export (bool) var source = true
export (bool) var output_signal = true
export (String) var value = "0000" setget change_value
export (bool) var correct = false setget set_correct

var cable_color
var hover = false
var connections = []
var green_led_sprite = preload("res://sprites/green_led.png")
var red_led_sprite = preload("res://sprites/red_led.png")

func signal_to_color(value):
	match value:
		"0000": return Color(0, 1, 1, 1)
		"0101": return Color(1, 1, 0, 1)
		"1010": return Color(1, 0, 1, 1)
		"1111": return Color(0, 0, 1, 1)

func _ready():
	if output_signal:
		cable_color = signal_to_color(value)
		$signal.value = [value, cable_color]
	else:
		$signal.visible = false
	if !source and output_signal:
		$pinLabelAnchor.scale.x = -1
		$pinLabelAnchor.position.x = -200
		$signal.position.x = -175
		$pinLabelAnchor/pinLabel/ledSprite.visible = true
	connect("clicked", get_parent(), "on_pin_clicked")
	connect("released", get_parent(), "on_pin_released")
	connect("hovering_on", get_parent(), "on_pin_enter_hovering")
	connect("hovering_off", get_parent(), "on_pin_exit_hovering")

func _process(delta):
	if hover:
		if Input.is_action_just_pressed("ui_click"):
			emit_signal("clicked", self)
		if Input.is_action_just_released("ui_click"):
			emit_signal("released", self)

func change_value(new_value):
	value = new_value
	
func set_correct(value):
	correct = value
	if correct:
		$pinLabelAnchor/pinLabel/ledSprite.texture = green_led_sprite
	else:
		$pinLabelAnchor/pinLabel/ledSprite.texture = red_led_sprite

func check_correct():
	if !source and connections.size() == 1 and connections[0].connected_from.value == value:
		set_correct(true)
	else:
		set_correct(false)

func add_connection(cable):
	connections.append(cable)
	print(connections)
	check_correct()

func remove_connection(cable):
	connections.erase(cable)
	check_correct()

func _on_pin_mouse_entered():
	hover = true
	emit_signal("hovering_on", self)

func _on_pin_mouse_exited():
	hover = false
	emit_signal("hovering_off", self)
