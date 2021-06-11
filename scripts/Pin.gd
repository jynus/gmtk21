extends Area2D

signal clicked(node)
export (bool) var source = true
export (Color) var cable_color = Color(1, 0, 0, 1)

var hover = false

func _ready():
	if !source:
		$pinLabelAnchor.scale.x = -1
		$pinLabelAnchor.position.x = -125
	connect("clicked", get_parent(), "on_pin_clicked")

func _process(delta):
	if hover and Input.is_action_just_pressed("ui_click"):
		emit_signal("clicked", self)

func _on_pin_mouse_entered():
	hover = true


func _on_pin_mouse_exited():
	hover = false
