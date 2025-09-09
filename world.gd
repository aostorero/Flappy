extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var wall_spawner: Node2D = $WallSpawner

func _ready() -> void:
	player.player_died.connect(wall_spawner._on_player_died)