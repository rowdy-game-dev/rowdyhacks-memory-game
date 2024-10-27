extends Node2D

@export var width_cards: float = 4
@export var height_cards: float = 3
@export var size_scale: float = 3

@export var horizontal_margin: float = 5
@export var vertical_margin: float = 10

const CARD_WIDTH := 20.0
const CARD_HEIGHT := 28.0

var card_scene := load("res://scenes/cards/empty_card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_grid(width_cards, height_cards)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_grid(width_cards:int, height_cards:int):
	for y in range(height_cards):
		for x in range(width_cards):
			var card_node = card_scene.instantiate()
			card_node.size_scale = size_scale
			card_node.position.x = (CARD_WIDTH * x * size_scale) + ((CARD_WIDTH*size_scale)/2) + (horizontal_margin * x)
			card_node.position.y = (CARD_HEIGHT * y * size_scale) + ((CARD_HEIGHT*size_scale)/2) + (vertical_margin * y)
			add_child(card_node)
