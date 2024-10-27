extends Node2D

signal on_flip(node)
signal on_unflip(node)

enum CardTypes {
	Empty,
	Emerald,
	Rose,
	Ruby,
	Shiappy,
	Silver,
	Yellow
}

@onready var sprite: AnimatedSprite2D = $"sprite"
@onready var area_2d: Area2D = $"Area2D"
@onready var timer: Timer = $"Timer"
@export var size_scale: float = 1
var original_position := Vector2(0,0)
var sprite_frames := load("res://assets/card animations/empty_card.tres")
var current_card = null
var flipped: bool = false
var matched: bool = false
var id: int
var type
var grid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(size_scale, size_scale)
	area_2d.input_event.connect(_on_area_2d_input_event)
	timer.timeout.connect(_on_timer_timeout)
	set_sprite_frames()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_input_event(viewport: Node, event: InputEventMouseButton, shape_idx: int) -> void:
	if not event.pressed or flipped or matched: return
	if grid:
		if len(grid.flipped_cards_list) >= 2 or grid.is_pair_flipped: return
	on_flip.emit(self)
	flipped = true
	sprite.play("flipping", 1, false)
	timer.start()

func set_type(type):
	self.type = type
	var animation = get_type_string()
	sprite_frames = load("res://assets/card animations/%s_card.tres" % animation)

func set_sprite_frames():
	sprite.sprite_frames = sprite_frames

func get_type_string() -> String:
	match type:
		CardTypes.Emerald:
			return "emerald"
		CardTypes.Rose:
			return "rose"
		CardTypes.Ruby:
			return "ruby"
		CardTypes.Shiappy:
			return "shiappy"
		CardTypes.Silver:
			return "silver"
		CardTypes.Yellow:
			return "yellow"
		_:
			return "empty"


func unflip():
	if matched: return
	on_unflip.emit(self)
	flipped = false
	sprite.play("flipping", -1, true)
	timer.stop()

func _on_timer_timeout() -> void:
	unflip()

func on_pair_flipped():
	timer.stop()
