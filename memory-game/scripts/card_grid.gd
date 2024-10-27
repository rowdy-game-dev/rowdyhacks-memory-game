extends Node2D

signal points_added(points)
signal game_won
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
const DEFAULT_ADDED_POINTS := 10

var card_types = null
var card_scene := load("res://scenes/cards/empty_card.tscn")
var cards_list := []
var is_pair_flipped := false
var flipped_cards_list := []
var game_ended := false

var wave_animation_counter: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pair_flipped.connect(on_pair_flipped)
	pair_unflipped.connect(on_pair_unflipped)
	pair_flipped_timer.timeout.connect(on_pair_timeout)
	make_grid(width_cards, height_cards)
	for card in cards_list:
		card.on_flip.connect(on_card_flip)
		card.on_unflip.connect(on_card_unflip)
	game_won.connect(on_game_won)

func win_game():
	for card in cards_list:
		for card2 in cards_list:
			if card.type == card2.type:	
				card.on_flip.emit(card)
				card2.on_flip.emit(card)
				card.flipped = true
				card2.flipped = true
				card.sprite.play("flipping", 1, false)
				card2.sprite.play("flipping", 1, false)
				card.timer.start()
				card2.timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	wave_animation(delta)

func get_random_type():
	if not card_types:
		var card_instance = card_scene.instantiate()
		card_types = []
		for card in card_instance.CardTypes.values():
			if card != card_instance.CardTypes.Empty:
				card_types.append_array([card,card])
	var i = RandomNumberGenerator.new().randi_range(0,len(card_types)-1)
	return card_types.pop_at(i)
			
func wave_animation(delta):
	wave_animation_counter += delta * 2
	for i in range(len(cards_list)):
		cards_list[i].position.y = cards_list[i].original_position.y + (
			(4.0) * sin(wave_animation_counter - (i % width_cards))
		)

func on_game_won():
	game_ended = true
	for i in range(len(cards_list)):
		cards_list[i].timer.stop()
		var newtimer = Timer.new()
		newtimer.wait_time = 1 + (i * 0.1)
		cards_list[i].newtimer = newtimer
		cards_list[i].add_child(cards_list[i].newtimer)
		cards_list[i].matched = false
		cards_list[i].newtimer.start()
		cards_list[i].newtimer.timeout.connect(cards_list[i].newtimer.stop)
		cards_list[i].newtimer.timeout.connect(cards_list[i].unflip)
		print(i)

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
			card_node.original_position = card_node.position
			card_node.id = id
			card_node.set_type(get_random_type())
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
	if flipped_cards_list[0].type == flipped_cards_list[1].type:
		on_pair_match()
	pair_flipped_timer.start()

func on_pair_unflipped():
	for card in flipped_cards_list:
		card.unflip()

func on_pair_match():
	for card in flipped_cards_list:
		card.matched = true
	flipped_cards_list.clear()
	points_added.emit(DEFAULT_ADDED_POINTS)
	if check_win(): game_won.emit()

func check_win():
	for card in cards_list:
		if not card.matched:
			return false
	return true

func on_pair_timeout():
	is_pair_flipped = false
	pair_flipped_timer.stop()
	pair_unflipped.emit()
