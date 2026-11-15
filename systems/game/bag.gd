class_name TileBag
extends RefCounted


## Stores tiles as letters for now
@warning_ignore("unused_private_class_variable")
var _tiles : Array[String] = []


func populate(distro:Distribution) -> void:
	_tiles.clear()
	for letter in distro.letter_amounts.keys():
		for _i in range(distro.letter_amounts.get(letter)):
			_tiles.append(letter)

func get_tile() -> String:
	# replace this with weighted stuff or whatever eventually
	return _tiles.pick_random()
