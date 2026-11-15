class_name TileBoard
extends Resource

signal updated_tiles(positions:Array[Vector2i])

@export var _data : Dictionary[Vector2i, int] = {}





func get_tile_data(pos:Vector2i) -> int:
	return _data.get(pos, 0)


func set_tile_data(pos:Vector2i, tile_data:int):
	if tile_data == 0:
		_data.erase(pos)
	else:
		_data[pos] = tile_data
	updated_tiles.emit([pos])


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
