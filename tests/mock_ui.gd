extends Control

@export var game:ScrabbleGame
#@export var player:TileBoard
#@export var opponent:TileBoard
@onready var player_board:GridContainer = $HBoxContainer/VBoxContainer/Player/PanelContainer/GridContainer
@onready var shuffle_button:TextureButton = find_child("ShuffleButton")
@onready var remove_tiles_button:TextureButton = find_child("RemoveTilesButton")
@onready var hand_container:HBoxContainer = find_child("HandContainer")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.initialize()
	player_board.game = game
	game.board.set_starting_word(game.distro)
	shuffle_button.pressed.connect(func() -> void:
		var children:Array[Node] = hand_container.get_children()
		children.shuffle()
		for child in children:
			hand_container.remove_child(child)
		for child in children:
			hand_container.add_child(child)
	)
	remove_tiles_button.pressed.connect(func() -> void:
		var temp_tiles:Dictionary[Vector2i, Tile] = game.board.get_temporary_tiles()
		var emptied_tiles:Dictionary[Vector2i, Tile]
		for coord:Vector2i in temp_tiles.keys():
			emptied_tiles[coord] = Tile.new()
			game.add_hand_tile(temp_tiles[coord])
		game.board.set_tiles_bulk(emptied_tiles)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
