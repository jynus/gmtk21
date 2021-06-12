extends Node2D



enum gate_types {
	OR,
	AND,
	XOR,
	NAND,
	NOR,
	NOT,
	XOR
}

export (gate_types) var type = gate_types.OR

var or_sprite = preload("res://sprites/or_gate.png")
var and_sprite = preload("res://sprites/and_gate.png")
var xor_sprite = preload("res://sprites/xor_gate.png")
var not_sprite = preload("res://sprites/not_gate.png")
var nand_sprite = preload("res://sprites/nand_gate.png")
var nor_sprite = preload("res://sprites/nor_gate.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	# setup sprits
	var sprite
	match type:
		gate_types.OR: sprite = or_sprite
		gate_types.AND: sprite = and_sprite
		gate_types.XOR: sprite = xor_sprite
		gate_types.NOT: sprite = not_sprite
		gate_types.NAND: sprite = nand_sprite
		gate_types.NOR: sprite = nor_sprite
	$gate_body/gateSprite.texture = sprite
	$gate_body/gateLabel.text = gate_types.keys()[type]

	# setup pins
	for pin in get_children():
		if pin.is_in_group("pins"):
			pin.gate = true
			if !pin.source:
				pin.connect("input_pin_changed", self, "on_input_pin_changed")

func execute(p1, p2):
	var pin1 = string_to_bits(p1)
	var pin2 = string_to_bits(p2)
	var output = 0
	match type:
		gate_types.OR: output = pin1 | pin2
		gate_types.AND: output = pin1 & pin2
		gate_types.XOR: output = pin1 ^ pin2
		gate_types.NOT: output = ~pin1 & 15
		gate_types.NAND: output = ~(pin1 & pin2) & 15
		gate_types.NOR: output = ~(pin1 | pin2) & 15
	print(output)

	return bits_to_string(output)

func on_input_pin_changed(pin):
	var pin1 = $pin1.value
	print("pin1: ", pin1)
	var pin2 = $pin2.value
	print("pin2: ", pin2)
	$pin3.value = execute(pin1, pin2)
	print("pin3 now has value: ", $pin3.value)

func string_to_bits(signal_value):
	var bits = 0
	for i in range(signal_value.length() - 1, -1, -1):
		if signal_value[i] != "0":
			bits += int(pow(2, signal_value.length() - i - 1))
	return bits

func bits_to_string(bits):
	var output = []
	var i = 0
	while bits > 0:
		output.push_front(str(bits % 2))
		bits = int(bits / 2)
		i +=1
	var str_output = PoolStringArray(output).join("")
	while str_output.length() < 4:
		str_output = "0" + str_output
	return str_output
