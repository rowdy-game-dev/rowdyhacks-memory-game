extends Node2D

@onready var sprite: Node = $"sprite"
@onready var area_2d: Area2D = $Area2D
@export var size_scale: float = 4
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.scale = Vector2(size_scale, size_scale)
	# collision_shape.scale = Vector2(size_scale, size_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEventMouseButton, shape_idx: int) -> void:
	sprite.play("silver_flip_in")
	timer.start()


func _on_timer_timeout() -> void:
	sprite.play("silver_flip_out")
	timer.stop()