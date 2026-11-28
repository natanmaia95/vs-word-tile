class_name TileBag extends Resource

signal shuffled()
signal emptied()

var _tiles : Array[Tile] = []

func shuffle() -> void:
	_tiles.shuffle()
	shuffled.emit()
	changed.emit()
	
func get_tile() -> Tile:
	var tile:Tile = _tiles.pop_back()
	changed.emit()
	if _tiles.size() == 0:
		emptied.emit()
	return tile

func add_tile(tile:Tile) -> void:
	_tiles.append(tile)
	changed.emit()
