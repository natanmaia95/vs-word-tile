extends Node2D

var distro : Distribution
var matches : Array[RegExMatch]

func _ready() -> void:
	distro = OfficialEnglishDistribution.new()
	
	var spaces = [" ", " ", "T", " ", " ", " ", "L", " "]
	var hand : Array[String] = ["A", "D", "E", "L", "O", "S", "T"]
	
	matches = WordSearch.find_matches_for_line(spaces, hand, distro.word_list)
	var matches_str = matches.map(func(m:RegExMatch): return m.get_string())
