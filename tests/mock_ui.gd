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
		var temp_tiles:Dictionary[Vector2i, int] = game.board.get_temporary_tiles()
		for coord:Vector2i in temp_tiles.keys():
			game.board.set_tile_data(coord,0)
			game.hand_changed.emit(game.hand)
			#game.add_hand_tile(temp_tiles[coord])
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
