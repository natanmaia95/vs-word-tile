class_name ScrabbleGame
extends Resource


var hand : Array[String] = []
var bag : TileBag
var board : TileBoard
var distro : Distribution


func initialize() -> void:
	board = TileBoard.new()
