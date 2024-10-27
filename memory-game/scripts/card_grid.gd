extends Node2D

signal points_added(points)
signal pair_flipped
signal pair_unflipped

@export var width_cards: int = 4
@export var height_cards: int = 3
@export var size_scale: float = 3

@export var horizontal_margin: int = 5
@export var vertical_margin: int = 10

@onready var pair_flipped_timer: Timer = $"pair_flipped_timer"

const CARD_WIDTH := 20.0
const CARD_HEIGHT := 28.0

var card_scene := load("res://scenes/cards/empty_card.tscn")
var cards_list := []
var is_pair_flipped := false
var flipped_cards_list := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pair_flipped.connect(on_pair_flipped)
	pair_unflipped.connect(on_pair_unflipped)
	pair_flipped_timer.timeout.connect(on_pair_timeout)
	make_grid(width_cards, height_cards)
	for card in cards_list:
		card.on_flip.connect(on_card_flip)
		card.on_unflip.connect(on_card_unflip)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_grid(width_cards:int, height_cards:int):
	var id = 0
	for y in range(height_cards):
		for x in range(width_cards):
			var card_node = card_scene.instantiate()
			card_node.size_scale = size_scale
			pair_flipped.connect(card_node.on_pair_flipped)
			card_node.grid = self
			card_node.position.x = (CARD_WIDTH * x * size_scale) + ((CARD_WIDTH*size_scale)/2) + (horizontal_margin * x)
			card_node.position.y = (CARD_HEIGHT * y * size_scale) + ((CARD_HEIGHT*size_scale)/2) + (vertical_margin * y)
			card_node.id = id
			cards_list.append(card_node)
			id += 1
			add_child(card_node)

func on_card_flip(node):
	if len(flipped_cards_list) < 2:
		flipped_cards_list.append(node)
		if len(flipped_cards_list) == 2: pair_flipped.emit()

func on_card_unflip(node):
	var index = flipped_cards_list.bsearch(node)
	flipped_cards_list.pop_at(index)

func on_pair_flipped():
	is_pair_flipped = true
	pair_flipped_timer.start()

func on_pair_unflipped():
	for card in flipped_cards_list:
		card.unflip()

func on_pair_timeout():
	is_pair_flipped = false
	pair_flipped_timer.stop()
	pair_unflipped.emit()