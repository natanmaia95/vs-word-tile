class_name ScrabbleGame
extends Resource


var hand:Hand
var bag : TileBag
var board : TileBoard
var distro : Distribution


func initialize() -> void:
	board = TileBoard.new()
	
	distro = OfficialEnglishDistribution.new()
	bag = distro.get_bag()
	
	hand = Hand.new()
	hand.draw_tiles(bag)

func draw_tiles(count:int = hand.max_hand_size) -> void:
	hand.draw_tiles(bag, count)

func player_place_tile(pos:Vector2i, tile:Tile) -> bool: # True if all tiles pass
	tile.placement = Tile.Placement.TEMPORARY
	board.set_tile(pos, tile)
	var failed_check = false
	var temporary_tiles = board.get_temporary_tiles()
	for coord:Vector2i in temporary_tiles.keys():
		var word_check:Array = _check_for_new_word(coord)
		if not word_check[0]:
			failed_check = true
			
	# Submit the tiles if we're all passed!
	if not failed_check:
		for coord:Vector2i in temporary_tiles.keys():
			var temp_tile:Tile = temporary_tiles[coord]
			temp_tile.placement = Tile.Placement.SUBMITTED
		board.set_tiles(temporary_tiles)
		draw_tiles()
		
	return true

func player_remove_tile(coord:Vector2i) -> void:
	board.set_tile(coord, null)

func _connected_tiles(from_coord:Vector2i, x_axis:bool) -> Dictionary[Vector2i, Tile]:
	var tiles:Dictionary[Vector2i, Tile]
	for i in range(board.size):
		var coord:Vector2i = from_coord + (Vector2i.RIGHT if x_axis else Vector2i.DOWN) * i
		var tile:Tile = board.get_tile(coord)
		if not tile or tile.is_empty():
			break
		tiles[coord] = tile
	return tiles

func _earliest_filled_tile(from_coord:Vector2i, x_axis:bool) -> Vector2i:
	if board.get_tile(from_coord).is_empty():
		printerr("Requested earliest filled tile from an empty coord")
		return from_coord
	
	for i in range(board.size):
		var coord:Vector2i = from_coord + (Vector2i.LEFT if x_axis else Vector2i.UP) * i
		var tile:Tile = board.get_tile(coord)
		if not tile or tile.is_empty():
			return coord + (Vector2i.RIGHT if x_axis else Vector2i.DOWN)
	return from_coord

func _coord_range(coords:Array[Vector2i], x_axis:bool) -> Array[int]:
	var minimum:int = coords[0].x if x_axis else coords[0].y
	var maximum:int = coords[0].x if x_axis else coords[0].y
	if coords.size() < 2:
		return [minimum,maximum]
	for i:int in range(coords.size()):
		minimum = min(minimum, coords[i].x if x_axis else coords[i].y)
		maximum = max(maximum, coords[i].x if x_axis else coords[i].y)
	return [minimum,maximum]

func _get_letters(from_coord:Vector2i, data:Dictionary[Vector2i, Tile], x_axis:bool) -> String:
	var ranges:Array[int] = _coord_range(data.keys(), x_axis)
	var letters:String = ""
	for i:int in range(ranges[0],ranges[1]+1):
		var coord:Vector2i = Vector2i(i, from_coord.y) if x_axis else Vector2i(from_coord.x, i)
		letters += data[coord].letter
	return letters

func _check_for_new_word(pos:Vector2i) -> Array:
	var horizontal_data:Dictionary[Vector2i, Tile] = _connected_tiles(_earliest_filled_tile(pos, true), true)
	var vertical_data:Dictionary[Vector2i, Tile] = _connected_tiles(_earliest_filled_tile(pos, false), false)
	
	var horizontal_letters = _get_letters(pos, horizontal_data, true)
	var vertical_letters = _get_letters(pos, vertical_data, false)
	
	print(horizontal_letters, ", " ,vertical_letters)

	var horizontal_words:Array[String] = []
	var horizontal_required:bool = horizontal_letters.length() > 1
	if horizontal_required:
		horizontal_words = WordSearch.find_words_in_string(horizontal_letters, distro.word_list)
		
	var vertical_words:Array[String] = []
	var vertical_required:bool = vertical_letters.length() > 1
	if vertical_required:
		vertical_words = WordSearch.find_words_in_string(vertical_letters, distro.word_list)
	
	var passes_check:bool = (!vertical_required or (vertical_required and not vertical_words.is_empty())) \
						and (!horizontal_required or (horizontal_required and not horizontal_words.is_empty()))
	if passes_check and (not horizontal_required and not vertical_required):
		passes_check = false
	return [passes_check, horizontal_words, vertical_words]
