class_name TileBag
extends RefCounted


## Stores tiles as letters for now
@warning_ignore("unused_private_class_variable")
var _tiles : Array[int] = []


func populate(distro:Distribution) -> void:
	_tiles.clear()
	for letter in distro.letter_amounts.keys():
		var points:int = distro.point_values.get(letter)
		print("letter",letter, "points",points)
		var data:int = 0
		data = TD.set_letter(letter, data)
		data = TD.set_points(points, data)
		for _i in range(distro.letter_amounts.get(letter)):
			_tiles.append(data)

func get_tile() -> int:
	# replace this with weighted stuff or whatever eventually
	var data:int = 0
	data = TD.set_temporary(true, _tiles.pick_random())
	return data
