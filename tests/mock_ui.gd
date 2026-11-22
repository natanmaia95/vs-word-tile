extends Control

@export var game:ScrabbleGame
#@export var player:TileBoard
#@export var opponent:TileBoard
@onready var player_board:GridContainer = $HBoxContainer/VBoxContainer/Player/PanelContainer/GridContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.initialize()
	player_board.game = game


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
