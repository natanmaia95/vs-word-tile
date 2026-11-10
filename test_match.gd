extends Node


@export var game_1 : ScrabbleGame
@export var game_2 : ScrabbleGame

func _ready() -> void:
	game_1.initialize()
