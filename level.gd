extends Node3D

var time: float = 120.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

func _ready() -> void:
	Global.coins = 0

func _process(delta) -> void:
	if time > 0:
		time -= delta
		time = max(time, 0)
	
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	
	$CanvasLayer/Panel/Minutes.text = "%02d:" % minutes
	$CanvasLayer/Panel/Seconds.text = "%02d." % seconds
	$CanvasLayer/Panel/Msec.text = "%03d" % msec
	$CanvasLayer/Panel/Score.text = "Coins:  %s/7" % Global.coins
	
	if time <= 0:
		get_tree().change_scene_to_file("res://lost_screen.tscn")

func stop() -> void:
	set_process(false)

func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
