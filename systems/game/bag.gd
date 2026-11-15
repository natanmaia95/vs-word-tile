class_name TileBag
extends RefCounted


## Stores tiles as letters for now
@warning_ignore("unused_private_class_variable")
var _tiles : Array[String] = []

var game : ScrabbleGame


func populate() -> void:
	_tiles.clear()
	for letter in game.distro.letter_amounts.keys():
		for _i in range(game.distro.letter_amounts.get(letter)):
			_tiles.append(letter)
