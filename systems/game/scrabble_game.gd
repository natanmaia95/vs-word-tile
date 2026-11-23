class_name ScrabbleGame
extends Resource
signal hand_changed(new_hand:Array[int])

var hand : Array[int] = []
var bag : TileBag
var board : TileBoard
var distro : Distribution


func initialize() -> void:
	distro = OfficialEnglishDistribution.new()
	board = TileBoard.new()
	bag = TileBag.new()
	bag.populate(distro)
	draw_hand_tiles()
	hand_changed.emit(hand)

func remove_hand_tiles(datas:Array[int]) -> void:
	for data in datas:
		hand.erase(data)
	hand_changed.emit(hand)

func draw_hand_tiles(hand_size:int = 7) -> void:
	for i:int in range(hand_size):
		hand.append(bag.get_tile())
	hand_changed.emit(hand)




func player_place_tile(pos:Vector2i, tile_data:int) -> bool: # True if all tiles pass
	board.set_tile_data(pos, tile_data)
	var failed_check = false
	var temporary_tiles = board.get_temporary_tiles()
	for coord:Vector2i in temporary_tiles.keys():
		var word_check:Array = _check_for_new_word(coord)
		if not word_check[0]:
			print_debug("Failed check at ",coord)
			failed_check = true
	# Submit the tiles if we're all passed!
	if not failed_check:
		print_debug("Submitting tiles!")
		remove_hand_tiles(temporary_tiles.values())
		for coord:Vector2i in temporary_tiles.keys():
			board.set_tile_data(coord, TD.set_temporary(false, temporary_tiles[coord]))
		draw_hand_tiles()
	return true

func player_remove_tile(pos:Vector2i) -> void:
	board.set_tile_data(pos, 0)

func _connected_tiles(from_coord:Vector2i, x_axis:bool) -> Dictionary[Vector2i, int]:
	var tiles:Dictionary[Vector2i, int]
	for i in range(board.size):
		var coord:Vector2i = from_coord + (Vector2i.RIGHT if x_axis else Vector2i.DOWN) * i
		var data:int = board.get_tile_data(coord)
		if TD.is_empty(data):
			break
		tiles[coord] = data
	return tiles 

func _earliest_filled_tile(from_coord:Vector2i, x_axis:bool) -> Vector2i:
	if TD.is_empty(board.get_tile_data(from_coord)):
		printerr("Requested earliest filled tile from an empty coord")
		return from_coord
	for i in range(board.size):
		var coord:Vector2i = from_coord + (Vector2i.LEFT if x_axis else Vector2i.UP) * i
		var data:int = board.get_tile_data(coord)
		if TD.is_empty(data):
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

func _get_letters(from_coord:Vector2i, data:Dictionary[Vector2i, int], x_axis:bool) -> String:
	var ranges:Array[int] = _coord_range(data.keys(), x_axis)
	var letters:String = ""
	for i:int in range(ranges[0],ranges[1]+1):
		var coord:Vector2i = Vector2i(i, from_coord.y) if x_axis else Vector2i(from_coord.x, i)
		letters += TD.get_letter(data[coord])
	return letters

func _check_for_new_word(pos:Vector2i) -> Array:
	var horizontal_data:Dictionary[Vector2i, int] = _connected_tiles(_earliest_filled_tile(pos, true), true)
	var vertical_data:Dictionary[Vector2i, int] = _connected_tiles(_earliest_filled_tile(pos, false), false)
	
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
	return [passes_check, horizontal_words, vertical_words]
