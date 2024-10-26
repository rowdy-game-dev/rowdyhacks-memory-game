extends Node2D

@onready var sprite: Node = $"sprite"
@onready var collision_shape = $"CollisionShape2D"
@export var size_scale: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.scale = Vector2(size_scale, size_scale)
	collision_shape.scale = Vector2(size_scale, size_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
