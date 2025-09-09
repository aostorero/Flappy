extends CharacterBody2D

@onready var top_sprite: Sprite2D = $TopSprite
@onready var bottom_sprite: Sprite2D = $BottomSprite
@onready var top_collision_shape: CollisionShape2D = $TopCollisionShape
@onready var bottom_collision_shape: CollisionShape2D = $BottomCollisionShape
@onready var hole_area: Area2D = $HoleArea
@onready var hole_collision_shape: CollisionShape2D = hole_area.get_node("HoleCollisionShape")

@export var speed = -100
@export var wall_width = 50
@export var hole_tallness = 200

func _ready() -> void:
	if not top_collision_shape.shape is RectangleShape2D:
		top_collision_shape.shape = RectangleShape2D.new()
	if not bottom_collision_shape.shape is RectangleShape2D:
		bottom_collision_shape.shape = RectangleShape2D.new()
	if not hole_collision_shape.shape is RectangleShape2D:
		hole_collision_shape.shape = RectangleShape2D.new()
	hole_area.body_entered.connect(_on_hole_area_body_entered)
	generate_wall()
	add_to_group("walls")

func _physics_process(delta: float) -> void:
	velocity.x = speed
	move_and_slide()
	if position.x < -wall_width / 2 - 90:
		teleport_wall()

func generate_wall() -> void:
	var viewport_height = get_viewport_rect().size.y
	
	#hole position
	var min_hole_height = hole_tallness / 2
	var max_hole_height = viewport_height - hole_tallness / 2
	var random_hole_height = randf_range(min_hole_height, max_hole_height)
	hole_collision_shape.shape.size = Vector2(wall_width, hole_tallness)
	hole_collision_shape.position = Vector2(0, random_hole_height - viewport_height / 2)
	
	#top wall
	var top_wall_height = random_hole_height - (hole_tallness / 2)
	top_collision_shape.shape.size = Vector2(wall_width, top_wall_height)
	top_collision_shape.position = Vector2(0, -viewport_height / 2 + top_wall_height / 2)
	
	var top_texture_size = top_sprite.texture.get_size()
	top_sprite.scale.x = wall_width / top_texture_size.x
	top_sprite.scale.y = top_wall_height / top_texture_size.y
	top_sprite.position = top_collision_shape.position
	
	#bottom wall
	var bottom_wall_height = viewport_height - (random_hole_height + (hole_tallness /2))
	bottom_collision_shape.shape.size = Vector2(wall_width, bottom_wall_height)
	bottom_collision_shape.position = Vector2(0, viewport_height / 2 - bottom_wall_height / 2)
	
	var bottom_texture_size = bottom_sprite.texture.get_size()
	bottom_sprite.scale.x = wall_width / bottom_texture_size.x
	bottom_sprite.scale.y = bottom_wall_height / bottom_texture_size.y
	bottom_sprite.position = bottom_collision_shape.position

func teleport_wall() -> void:
	var viewport_width = get_viewport_rect().size.x
	
	position.x = viewport_width + wall_width / 2 + 10
	
	generate_wall()

func _on_hole_area_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		ScoreManager.add_score()
