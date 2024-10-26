extends Node2D

var width_cards: float = 3
var height_cards: float = 3

const CARD_WIDTH := 20.0
const CARD_HEIGHT := 28.0

var card_scene := load("res://scenes/cards/empty_card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var x: int = 0
	var y: int = 0

	while y < height_cards:
		while x < width_cards:
			var card_node = card_scene.instantiate()
			card_node.position.x = (CARD_WIDTH * x) + (CARD_WIDTH/2)
			card_node.position.y = 14
			add_child(card_node)
			print(card_node.position)
			x+=1
		y+=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
