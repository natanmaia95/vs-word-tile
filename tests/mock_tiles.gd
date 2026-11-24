extends GridContainer
const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")

var game:ScrabbleGame:
	set(new):
		game = new
		_initialize_board()
	
func _initialize_board() -> void:
	if not is_node_ready() or not game:
		return
	columns = game.board.size
	for y:int in range(columns):
		for x:int in range(columns):
			var tile:VisualTile = VISUAL_TILE.instantiate()
			add_child(tile)
			var coord:Vector2i = Vector2i(x,y)
			tile.placed.connect(tile_placed.bind(coord))
			tile.removed.connect(tile_removed.bind(coord))
	
	game.board.updated_tiles.connect(func(positions:Array[Vector2i]) -> void:
		for coord:Vector2i in positions:
			var visual_tile:VisualTile = get_child(coord.y * columns + coord.x)
			visual_tile.data = game.board.get_tile_data(coord)
	)
func tile_placed(data:int, coord:Vector2i) -> void:
	print("Tile placed (temporarily) at ",coord,": ",data)
	game.player_place_tile(coord, data)
	#game.remove_hand_tiles([data])

func tile_removed(coord:Vector2i) -> void:
	print("Tile removed from ", coord)
	game.player_remove_tile(coord)
