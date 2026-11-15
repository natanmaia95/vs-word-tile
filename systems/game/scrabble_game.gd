class_name ScrabbleGame
extends Resource
signal hand_changed(new_hand:Array[String])

var hand : Array[String] = []
var bag : TileBag
var board : TileBoard
var distro : Distribution


func initialize() -> void:
	distro = OfficialEnglishDistribution.new()
	board = TileBoard.new()
	bag = TileBag.new()
	bag.populate(distro)
	draw_hand_tiles()
	hand_changed.emit(hand)

func remove_hand_tiles(letters:Array[String]) -> void:
	for letter in letters:
		hand.erase(letter)
	hand_changed.emit(hand)

func draw_hand_tiles(hand_size:int = 7) -> void:
	for i:int in range(hand_size):
		hand.append(bag.get_tile())
	hand_changed.emit(hand)
