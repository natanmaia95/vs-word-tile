@abstract class_name Distribution extends Resource

class Data extends RefCounted:
	var letter:String
	var count:int
	var points:int
	func _init(_letter, _count, _points) -> void:
		letter = _letter
		count = _count
		points = _points

var _data:Array[Distribution.Data]

@export_multiline var word_list : String

func load_word_list(path:String) -> bool:
	print_debug("loading word list at: ", path)
	if FileAccess.file_exists(path):
		var file_text = FileAccess.get_file_as_string(path)
		word_list = file_text
		return true
	return false

func get_bag() -> TileBag:
	var bag = TileBag.new()
	for data:Distribution.Data in _data:
		var tile:Tile = Tile.new()
		tile.letter = data.letter
		tile.points = data.points
		for i:int in range(data.count):
			bag.add_tile(tile.duplicate())
	bag.shuffle()
	return bag

func get_tile_from_letter(letter:String) -> Tile:
	var tile:Tile = Tile.new()
	var matched_data:Array[Distribution.Data] = _data.filter(func(v:Distribution.Data) -> bool: return v.letter == letter)
	if matched_data.size() != 1:
		printerr('Tried to get a tile from letter "{0}", but got {1} results'.format([letter,matched_data.size()]))
		return tile
	var data:Distribution.Data = matched_data[0]
	tile.letter = data.letter
	tile.points = data.points
	return tile
