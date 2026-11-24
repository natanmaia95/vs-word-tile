extends Control

@export var game:ScrabbleGame
#@export var player:TileBoard
#@export var opponent:TileBoard
@onready var player_board:GridContainer = $HBoxContainer/VBoxContainer/Player/PanelContainer/GridContainer
@onready var shuffle_button:TextureButton = find_child("ShuffleButton")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.initialize()
	player_board.game = game
	game.board.set_starting_word(game.distro)
	shuffle_button.pressed.connect(func() -> void:
		game.shuffle_hand()
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
