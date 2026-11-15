extends Control

@export var player:TileBoard
@export var opponent:TileBoard
@onready var player_board:GridContainer = $HBoxContainer/VBoxContainer/Player/GridContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_board.board = player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
