class_name ScrabbleGame
extends Node



var board : TileBoard

@export var visuals : Node = null


func initialize() -> void:
	board = TileBoard.new()
	
	if visuals:
		visuals.initialize(self)


func _process(delta: float) -> void:
	if board: board.tick_render(delta)
