extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003  # Adjust for faster/slower camera movement

@onready var camera_controller: Node3D = $Camera_Controller  # Explicit type

var yaw: float = 0.0  # Left-right rotation
var pitch: float = 0.0  # Up-down rotation (if needed)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Hide and capture mouse

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * MOUSE_SENSITIVITY
		pitch -= event.relative.y * MOUSE_SENSITIVITY
		pitch = clamp(pitch, -1.2, 1.2)  # Prevent camera flipping

	# ✅ Press ESC to exit the game
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		get_tree().quit()

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Ensure the camera's basis is valid before using it
	if camera_controller:
		# Get camera's forward and right directions (FLIP forward direction)
		var forward: Vector3 = camera_controller.basis.z.normalized()  # Removed the negative sign (-)
		var right: Vector3 = camera_controller.basis.x.normalized()

		# Compute movement direction relative to the camera
		var move_direction: Vector3 = (forward * input_dir.y + right * input_dir.x).normalized()

		if move_direction.length() > 0.1:
			velocity.x = move_direction.x * SPEED
			velocity.z = move_direction.z * SPEED

			# Rotate player to face the movement direction
			rotation.y = lerp_angle(rotation.y, atan2(-move_direction.x, -move_direction.z), 0.1)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	# Apply smooth camera rotation
	camera_controller.rotation.y = lerp_angle(camera_controller.rotation.y, yaw, 0.1)
	camera_controller.rotation.x = lerp_angle(camera_controller.rotation.x, pitch, 0.1)

	# Keep camera following player's position
	camera_controller.position = lerp(camera_controller.position, position, 0.1)
