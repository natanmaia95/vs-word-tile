class_name TileBoard
extends Resource

signal updated_tiles(positions:Array[Vector2i])

@export var size : int = 9 ## do we want to change this to width x height vector2i?

@export var _data : Dictionary[Vector2i, Tile] = {}

func get_tile(coord:Vector2i) -> Tile:
	return _data.get(coord)

func set_tile(coord:Vector2i, tile:Tile) -> void:
	set_tiles({coord:tile})

func set_tiles(tiles:Dictionary[Vector2i, Tile]) -> void:
	_data.merge(tiles, true)
	updated_tiles.emit(tiles.keys())

func get_temporary_tiles() -> Dictionary[Vector2i, Tile]:
	var tiles:Dictionary[Vector2i, Tile]
	for coord:Vector2i in _data.keys():
		var tile:Tile = get_tile(coord)
		if tile and tile.placement == Tile.Placement.TEMPORARY:
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
