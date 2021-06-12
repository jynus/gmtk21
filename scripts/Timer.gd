extends Node2D

signal timeout(node)

export (int) var timeout_seconds = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	$countdownTimer.wait_time = timeout_seconds
	$countdownTimer.start()

func stop():
	$countdownTimer.paused = true

func _process(delta):
	var time_left = $countdownTimer.get_time_left()
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	var hundreth_seconds = floor((time_left - minutes * 60 - seconds) * 100)
	$timerLabel/timerSprite/timerCountdown.text = "%02d" % minutes + ":" + "%02d" %seconds + "." + "%02d" % hundreth_seconds


func _on_countdownTimer_timeout():
	$countdownTimer.stop()
	emit_signal("timeout", self)

