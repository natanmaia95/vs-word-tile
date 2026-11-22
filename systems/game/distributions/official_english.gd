class_name OfficialEnglishDistribution
extends Distribution

func _init() -> void:
	letter_amounts = {
		"K": 1, "J": 1, "X": 1, "Q": 1, "Z": 1,
		"B": 2, "C": 2, "M": 2, "P": 2,
		"F": 2, "H": 2, "V": 2, "W": 2, "Y": 2,
		"G": 3, "L": 4, "S": 4, "U": 4, "D": 4,
		"N": 6, "R": 6, "T": 6,
		"O": 8, "A": 9, "I": 9, "E": 12
	}
	point_values = {
		"A": 1, "B": 3, "C": 3, "D": 2, "E": 1, 
		"F": 4, "G": 2, "H": 4, "I": 1, "J": 8, 
		"K": 5, "L": 1, "M": 3, "N": 1, "O": 1, 
		"P": 3, "Q": 10, "R": 1, "S": 1, "T": 1, 
		"U": 1, "V": 4, "W": 4, "X": 8, "Y": 4, "Z": 10
	}
	word_list_path = "res://assets/word_lists/enable2k.txt"
	load_word_list(word_list_path)
