extends Node2D

@export var wall_scene: PackedScene
@export var spawn_time = 3
const MAX_WALLS = 4
var wall_counter = 0

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = spawn_time
	timer.start()

func _on_timer_timeout() -> void:
	if wall_counter < MAX_WALLS:
		var new_wall = wall_scene.instantiate()
		get_tree().root.add_child(new_wall)
		new_wall.global_position = global_position
		wall_counter = wall_counter + 1
		timer.start()
	else:
		pass
