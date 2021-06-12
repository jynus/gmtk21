extends Node2D

var source_pin = null
var dragging = false
var cable_scene = preload("res://scenes/Cable.tscn")
var current_cable = null
var hovering = false
var hovering_on = null
var output_pins = []

func _ready():
	# gather a list of output pins to later check for win state
	for node in get_children():
		if node.is_in_group("pins") && !node.source:
			output_pins.append(node)

func move_cable(pos):
	$cableEndSprite.position = pos - Vector2(5, 0)
	var cable_vector = pos - source_pin.position
	if is_instance_valid(current_cable):
		current_cable.rotation = cable_vector.angle() + PI/2
		current_cable.scale.y = cable_vector.length()

func _process(delta):
	if dragging:
		if Input.is_action_just_released("ui_click") and !hovering:
			dragging = false
			remove_cable(current_cable)
			current_cable = null
		else:
			move_cable(get_global_mouse_position())
	check_win_state()

func check_win_state():
	# if every output pin is correct, trigger win
	for pin in output_pins:
		if !pin.correct:
			return
	win_game()

func add_new_connection(from, to, cable):
	move_cable(to.position)
	dragging = false
	cable.connect_cable(from, to)
	current_cable = null
	$cableEndSprite.visible = false

func start_new_cable(from):
	source_pin = from
	dragging = true
	current_cable = cable_scene.instance()
	current_cable.color = from.cable_color
	from.add_child(current_cable)
	$cableEndSprite.visible = true
	move_cable(get_global_mouse_position())

func remove_cable(cable):
	if is_instance_valid(cable):
		cable.disconnect_cable()
		cable.queue_free()
	$cableEndSprite.visible = false

func on_pin_clicked(node):
	if !dragging && node.source:
		start_new_cable(node)

func on_pin_released(node):
	if node == source_pin:
		dragging = false
		remove_cable(current_cable)
		current_cable = null
	else:
		add_new_connection(source_pin, node, current_cable)
	source_pin = null

func on_pin_enter_hovering(node):
	hovering = true
	hovering_on = node
	
func on_pin_exit_hovering(node):
	hovering = false
	hovering_on = null

func on_cable_clicked(node):
	print("you clicked a cable!")
	if !hovering and node.removable:
		remove_cable(node)

func on_cable_released(node):
	pass

func disable_gameplay():
	$popUpAnchor/popUpPanel.visible = true
	$timer.stop()
	dragging = false
	source_pin = null
	hovering = false
	hovering_on = null
	current_cable = null

func lose_game():
	$popUpAnchor/popUpPanel/popUpLabel.text = "YOU LOSE"
	disable_gameplay()

func win_game():
	$popUpAnchor/popUpPanel/popUpLabel.text = "YOU WIN"
	disable_gameplay()
	
func _on_timer_timeout(node):
	lose_game()
