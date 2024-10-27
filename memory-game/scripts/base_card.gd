extends Node2D

signal on_flip(node)
signal on_unflip(node)

@onready var sprite: AnimatedSprite2D = $"sprite"
@onready var area_2d: Area2D = $"Area2D"
@onready var timer: Timer = $"Timer"
@export var size_scale: float = 1
var flipped: bool = false
var id: int
var type
var grid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(size_scale, size_scale)
	area_2d.input_event.connect(_on_area_2d_input_event)
	timer.timeout.connect(_on_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEventMouseButton, shape_idx: int) -> void:
	if not event.pressed or flipped or grid.is_pair_flipped: return
	if grid and len(grid.flipped_cards_list) >= 2: return
	on_flip.emit(self)
	flipped = true
	sprite.play("flipping", 1, false)
	timer.start()

func unflip():
	on_unflip.emit(self)
	flipped = false
	sprite.play("flipping", -1, true)
	timer.stop()

func _on_timer_timeout() -> void:
	unflip()

func on_pair_flipped():
	timer.stop()
