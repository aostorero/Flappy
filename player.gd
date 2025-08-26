extends CharacterBody2D

const JUMP_VELOCITY = -400.0
var can_jump = true
@onready var jump_timer: Timer = $JumpTimer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false
		jump_timer.start()

	move_and_slide()


func _on_jump_timer_timeout() -> void:
	can_jump = true
