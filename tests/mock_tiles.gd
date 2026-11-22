extends GridContainer
const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")

var game:ScrabbleGame:
	set(new):
		game = new
		_initialize_board()
	
func _initialize_board() -> void:
	if not is_node_ready() or not game:
		return
	
	for y:int in range(columns):
		for x:int in range(columns):
			var tile:VisualTile = VISUAL_TILE.instantiate()
			add_child(tile)
			tile.placed.connect(tile_placed.bind(Vector2i(x,y)))

func tile_placed(data:int, coord:Vector2i) -> void:
	print("Tile placed (temporarily) at ",coord,": ",data)
	game.player_place_tile(coord, data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
