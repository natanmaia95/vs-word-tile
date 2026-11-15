extends GridContainer
const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")

var board:TileBoard:
	set(new):
		board = new
		_initialize_board()
	
func _initialize_board() -> void:
	if not is_node_ready() or not board:
		return
	
	for y:int in range(columns):
		for x:int in range(columns):
			var tile:VisualTile = VISUAL_TILE.instantiate()
			add_child(tile)
			tile.placed.connect(tile_placed.bind(Vector2i(x,y)))

func tile_placed(letter:String, coord:Vector2i) -> void:
	print("Tile placed at ",coord,": ",letter)
	# maybe store this in pending tiles or something like that, until a word is formed?

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
