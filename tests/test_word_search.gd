extends Node2D

var distro : Distribution
var matches : Array[RegExMatch]

func _ready() -> void:
	distro = OfficialEnglishDistribution.new()
	print(distro.load_word_list())
	#print(distro.word_list)
	
	var spaces = [" ", " ", "T", " ", " ", " ", "L", " "]
	var hand : Array[String] = ["A", "D", "E", "L", "O", "S", "T"]
	
	var matches = WordSearch.find_matches_for_line(spaces, hand, distro.word_list)
	print(matches)
