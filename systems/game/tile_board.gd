class_name TileBoard
extends Resource

signal updated_tiles(positions:Array[Vector2i])

@export var size : int = 9 ## do we want to change this to width x height vector2i?

@export var _data : Dictionary[Vector2i, Tile] = {}

func get_tile_at(coord:Vector2i) -> Tile:
	return _data.get(coord)

func set_tile(coord:Vector2i, tile:Tile) -> void:
	set_tiles({coord:tile})

func set_tiles(tiles:Dictionary[Vector2i, Tile]) -> void:
	_data.merge(tiles, true)
	updated_tiles.emit(tiles.keys())

func get_temporary_tiles() -> Dictionary[Vector2i, Tile]:
	var tiles:Dictionary[Vector2i, Tile]
	for coord:Vector2i in _data.keys():
		var tile:Tile = get_tile_at(coord)
		if tile.placement == Tile.Placement.TEMPORARY:
			tiles[coord] = tile
	return tiles

func set_starting_word(distro:Distribution) -> void:
	var starting_word:String = ""
	var words:Array = distro.word_list.split("\n") as Array
	while starting_word.length() > size or starting_word.length() < 4:
		starting_word = words.pick_random().to_upper()
		
	print_debug("Found starting word ", starting_word)
	@warning_ignore("integer_division")
	var mid_point:int = size/2
	@warning_ignore("integer_division")

	var half_word = starting_word.length()/2 - (0 if starting_word.length()%2 == 1 else 1)
	var tiles:Dictionary[Vector2i, Tile]
	for i:int in range(starting_word.length()):
		var x = mid_point-half_word+i
		var tile:Tile = distro.get_tile_from_letter(starting_word[i])
		tile.placement = Tile.Placement.SUBMITTED
		tiles[Vector2i(x, mid_point)] = tile
	
	set_tiles(tiles)

func compare_data_with(other:Dictionary[Vector2i, Tile]) -> Array[Vector2i]:
	var changes : Array[Vector2i] = []
	# merge keys with no repeats
	var merged_keys = _merge_arrays(_data.keys(), other.keys())
	# note the repeats
	for key in merged_keys:
		if not _data.has(key): changes.append(key)
		if not other.has(key): changes.append(key)
	return changes

func _merge_arrays(arr1:Array, arr2:Array) -> Array:
	var my_set = {}
	for item in arr1:
		my_set[item] = 1
	for item in arr2:
		my_set[item] = 2
	return my_set.keys()
