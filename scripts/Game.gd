extends Node2D

var source_pin = null
var dragging = false
var cable_scene = preload("res://scenes/Cable.tscn")
var current_cable = null
var hovering = false
var hovering_on = null
var output_pins = []
var won = false
var lost = false
var win_sound = preload("res://music/win2.ogg")
var loss_sound = preload("res://music/loss.ogg")

func _ready():
	if GlobalVariables.music:
		GlobalVariables.stop()
		GlobalVariables.stream = GlobalVariables.song2
		GlobalVariables.play()
	# gather a list of output pins to later check for win state
	for node in get_children():
		if node.is_in_group("pins") && !node.source:
			output_pins.append(node)

func move_cable(pos):
	$cableEndSprite.position = pos - Vector2(5, 0)
	var cable_vector = pos - source_pin.global_position
	if is_instance_valid(current_cable):
		current_cable.rotation = cable_vector.angle() + PI/2
		current_cable.scale.y = cable_vector.length()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and !won and !lost:
		pause_game()
	if dragging:
		if Input.is_action_just_released("ui_click") and !hovering:
			dragging = false
			remove_cable(current_cable)
			current_cable = null
		else:
			move_cable(get_global_mouse_position())
	check_win_state()

func pause_game():
	if GlobalVariables.music:
		GlobalVariables.stop()
	$popUpAnchor/popUpPanel/popUpLabel.text = "GAME PAUSED"
	$popUpAnchor/popUpPanel/nextButton.text = "reset level"
	$popUpAnchor/popUpPanel/backButton.text = "back"
	$popUpAnchor/popUpPanel.self_modulate = Color(1,1,1,1)
	$popUpAnchor/popUpPanel/continueButton.visible = true
	disable_gameplay()
	$popUpAnchor/popUpPanel/continueButton.connect("continue_game", self, "unpause_game")

func unpause_game(node):
	if GlobalVariables.music:
		GlobalVariables.play()
	$popUpAnchor/popUpPanel/continueButton.disconnect("continue_game", self, "unpause_game")
	$popUpAnchor/popUpPanel.self_modulate = Color(1,1,1,0.68)
	enable_gameplay()

func check_win_state():
	if !won:
		# if every output pin is correct, trigger win
		for pin in output_pins:
			if !pin.correct:
				return
		win_game()

func add_new_connection(from, to, cable):
	if cable == null:
		return
	move_cable(to.global_position)
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
	elif source_pin != null:
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
	if get_node_or_null("timer"):
		$timer/countdownTimer.paused = true
	dragging = false
	source_pin = null
	hovering = false
	hovering_on = null
	current_cable = null
	$popUpAnchor/popUpPanel.visible = true
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.connect("timeout", self, "show_buttons")
	timer.start()

func enable_gameplay():
	if get_node_or_null("timer"):
		$timer/countdownTimer.paused = false
	dragging = false
	source_pin = null
	hovering = false
	hovering_on = null
	current_cable = null
	$popUpAnchor/popUpPanel.visible = false
	$popUpAnchor/popUpPanel/nextButton.disabled = true
	$popUpAnchor/popUpPanel/backButton.disabled = true
	$popUpAnchor/popUpPanel/continueButton.disabled = true

func show_buttons():
	$popUpAnchor/popUpPanel/nextButton.disabled = false
	$popUpAnchor/popUpPanel/backButton.disabled = false
	$popUpAnchor/popUpPanel/continueButton.disabled = false

func lose_game():
	if GlobalVariables.music:
		GlobalVariables.stop()
	lost = true
	$popUpAnchor/popUpPanel/popUpLabel.text = "YOU LOSE"
	$popUpAnchor/popUpPanel/nextButton.text = "retry"
	$popUpAnchor/sfx.stream = loss_sound
	$popUpAnchor/sfx.autoplay = false
	$popUpAnchor/sfx.play()
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "sfx_end")
	timer.wait_time = 5
	timer.start()
	disable_gameplay()

func win_game():
	if GlobalVariables.music:
		GlobalVariables.stop()
	won = true
	GlobalVariables.won()
	$popUpAnchor/popUpPanel/popUpLabel.text = "YOU WIN"
	$popUpAnchor/popUpPanel/nextButton.text = "next level"
	$popUpAnchor/sfx.stream = win_sound
	$popUpAnchor/sfx.autoplay = false
	$popUpAnchor/sfx.play()
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "sfx_end")
	timer.wait_time = 5
	timer.start()
	disable_gameplay()

func sfx_end():
	$popUpAnchor/sfx.stop()
	$popUpAnchor/sfx.stream = null

func _on_timer_timeout(node):
	lose_game()

