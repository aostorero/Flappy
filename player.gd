extends CharacterBody2D

signal player_died
enum Status {ALIVE, DEAD, PAUSE}
const JUMP_VELOCITY = -400.0
var can_jump = true
var state = Status.ALIVE
@onready var jump_timer: Timer = $JumpTimer

func _ready() -> void:
	state = Status.ALIVE

func _physics_process(delta: float) -> void:
	match state:
		Status.ALIVE:
			# Add the gravity.
			if not is_on_floor():
				velocity += get_gravity() * delta
			# Handle jump.
			if Input.is_action_just_pressed("ui_accept") and can_jump:
				velocity.y = JUMP_VELOCITY
				can_jump = false
				jump_timer.start()
		Status.DEAD:
			if not is_on_floor():
				velocity += get_gravity() * delta
		Status.PAUSE:
			velocity = Vector2.ZERO
	var collisioned = move_and_slide()
	
	if collisioned and state == Status.ALIVE:
		for i in get_slide_collision_count():
			var colision = get_slide_collision(i)
			if colision.get_collider().name == "Wall" or colision.get_collider() is StaticBody2D:
				change_state(Status.DEAD)
				player_died.emit()

func change_state(new_state):
	state = new_state

func _on_jump_timer_timeout() -> void:
	can_jump = true
