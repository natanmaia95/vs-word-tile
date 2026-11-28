extends Control

@export var game:ScrabbleGame
@onready var player_board:GridContainer = $HBoxContainer/VBoxContainer/Player/PanelContainer/GridContainer
@onready var shuffle_button:TextureButton = find_child("ShuffleButton")
@onready var remove_tiles_button:TextureButton = find_child("RemoveTilesButton")
@onready var hand_container:HBoxContainer = find_child("HandContainer")

func _ready() -> void:
	game.initialize()
	hand_container.hand = game.hand
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
			emptied_tiles[coord] = null
		game.board.set_tiles(emptied_tiles)
		game.hand.add_bulk(temp_tiles.values())
	)
