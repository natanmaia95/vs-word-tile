class_name Hand extends Resource
@export var max_hand_size:int = 7
var _tiles:Array[Tile]

func get_tile(index:int) -> Tile:
	if _tiles.size()-1 < index:
		return null
	return _tiles.get(index)

func insert(index, tile:Tile) -> void:
	tile.placement = Tile.Placement.IN_HAND
	index = min(_tiles.size(), index)
	_tiles.insert(index, tile)
	changed.emit()

func add(tile:Tile) -> void:
	add_bulk([tile])

func add_bulk(tiles:Array[Tile]):
	for tile in tiles:
		tile.placement = Tile.Placement.IN_HAND
	_tiles.append_array(tiles)
	changed.emit()

func remove(tile:Tile) -> void:
	remove_bulk([tile])

func remove_bulk(tiles:Array[Tile]) -> void:
	for tile in tiles:
		_tiles.erase(tile)
	changed.emit()

func shuffle() -> void:
	_tiles.shuffle()
	changed.emit()

func draw_tiles(bag:TileBag, count:int = max_hand_size) -> void:
	var tiles:Array[Tile] = []
	for i:int in range(_tiles.size(), min(_tiles.size()+count, max_hand_size)):
		tiles.append(bag.get_tile())
	add_bulk(tiles)
