class_name ScrabbleGame
extends Resource
signal hand_changed(new_hand:Array[int])

var hand : Array[int] = []
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




func player_place_tile(pos:Vector2i, tile_data:int) -> bool:
	if board.get_tile_data(pos) == 0: return false
	board.set_tile_data(pos, tile_data)
	_check_for_new_word(pos) #check this row and column for words *including this position*
	return true



func _check_for_new_word(pos:Vector2i):
	print("Called checking for new ord?")
	var hor_list : Array[String] = []
	var ver_list : Array[String] = []
	for i in range(board.size):
		hor_list.append(board.get_letter_at(Vector2i(i, pos.y)))
		ver_list.append(board.get_letter_at(Vector2i(pos.x, i)))
	print(hor_list,ver_list)
	var hor_after := "".join(hor_list)
	var ver_after := "".join(ver_list)
	hor_list[pos.x] = " "
	ver_list[pos.y] = " "
	var hor_before := "".join(hor_list)
	var ver_before := "".join(ver_list)
	
	var words_before = WordSearch.find_words_in_string(hor_before, distro.word_list)
	words_before.append_array(WordSearch.find_words_in_string(ver_before, distro.word_list))
	var words_after = WordSearch.find_words_in_string(hor_after, distro.word_list)
	words_after.append_array(WordSearch.find_words_in_string(ver_after, distro.word_list))
	
	# TODO: compare before and after lists
