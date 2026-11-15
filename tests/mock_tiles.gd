extends GridContainer
const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")

var board:TileBoard:
	set(new):
		board = new
		_initialize_board()

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#for y in range(columns):
		#for x in range(columns):
			#var tile:VisualTile = VISUAL_TILE.instantiate()
			#add_child(tile)
	#await get_tree().process_frame
	#get_parent().scale = Vector2(.1,.1)
	
func _initialize_board() -> void:
	if not is_node_ready() or not board:
		return
	
	for y:int in range(columns):
		for x:int in range(columns):
			var tile:VisualTile = VISUAL_TILE.instantiate()
			#tile.coord = Vector2i(x,y)
			add_child(tile)
			#tile.gui_input.connect(func(event:InputEvent) -> void:
				#if event is InputEventMouseButton and event.is_pressed():
					#tile.active = not tile.active
			#)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
