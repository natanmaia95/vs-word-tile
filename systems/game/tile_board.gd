class_name TileBoard
extends Resource

signal updated_tiles(positions:Array[Vector2i])

@export var size : int = 9 ## do we want to change this to width x height vector2i?

@export var _data : Dictionary[Vector2i, int] = {}






func get_tile_data(pos:Vector2i) -> int:
	return _data.get(pos, 0)

func get_letter_at(pos:Vector2i) -> String:
	var tile_data := get_tile_data(pos)
	if tile_data == 0: return " "
	return TD.get_letter(tile_data)

func set_tile_data(pos:Vector2i, tile_data:int):
	_set_tiles([[pos, tile_data]])

## Receives an array of arrays: [pos, tile]
func set_tiles_bulk(list:Array[Array]):
	_set_tiles(list)

## Receives an array of arrays: [pos, tile]
func _set_tiles(list:Array[Array]):
	var changed_positions : Array[Vector2i] = []
	for item in list:
		var pos : Vector2i = item[0]
		var tile_data : int = item[1]
		changed_positions.append(pos)
		if tile_data == 0:
			_data.erase(pos)
		else:
			_data[pos] = tile_data
	updated_tiles.emit(changed_positions)







func compare_data_with(other:Dictionary[Vector2i, int]) -> Array[Vector2i]:
	var changes : Array[Vector2i] = []
	# merge keys with no repeats
	var merged_keys = _merge_arrays(_data.keys(), other.keys())
	# note the repeats
	for key in merged_keys:
		if not _data.has(key): changes.append(key)
		if not other.has(key): changes.append(key)
	return changes


func merge_data_with(other:Dictionary[Vector2i, int]) -> void:
	var changes : Array[Vector2i] = compare_data_with(other)
	for pos in changes:
		if not other.has(pos) and _data.has(pos):
			_data.erase(pos)
		else:
			_data[pos] = other[pos]
	updated_tiles.emit(changes)



func _merge_arrays(arr1:Array, arr2:Array) -> Array:
	var my_set = {}
	for item in arr1:
		my_set[item] = 1
	for item in arr2:
		my_set[item] = 2
	return my_set.keys()
