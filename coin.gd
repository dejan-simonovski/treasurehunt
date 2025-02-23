extends Area3D

const ROT_SPEED = 2 # Numbers of degrees the coin rotates every frame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))


func _on_body_entered(body: Node3D) -> void:
	Global.coins += 1
	if Global.coins >= Global.NUM_COINS_WIN:
		get_tree().change_scene_to_file("res://win_screen.tscn")
	queue_free()
