class_name OfficialEnglishDistribution extends Distribution

func _init() -> void:
	_data = [
		Distribution.Data.new("A", 9, 1),
		Distribution.Data.new("B", 2, 3),
		Distribution.Data.new("C", 2, 3),
		Distribution.Data.new("D", 4, 2),
		Distribution.Data.new("E", 12, 1),
		Distribution.Data.new("F", 2, 4),
		Distribution.Data.new("G", 3, 2),
		Distribution.Data.new("H", 2, 4),
		Distribution.Data.new("I", 9, 1),
		Distribution.Data.new("J", 1, 8),
		Distribution.Data.new("K", 1, 5),
		Distribution.Data.new("L", 4, 1),
		Distribution.Data.new("M", 2, 3),
		Distribution.Data.new("N", 6, 1),
		Distribution.Data.new("O", 8, 1),
		Distribution.Data.new("P", 2, 3),
		Distribution.Data.new("Q", 2, 10),
		Distribution.Data.new("R", 6, 1),
		Distribution.Data.new("S", 4, 1),
		Distribution.Data.new("T", 6, 1),
		Distribution.Data.new("U", 4, 1),
		Distribution.Data.new("V", 2, 4),
		Distribution.Data.new("W", 6, 3),
		Distribution.Data.new("X", 1, 8),
		Distribution.Data.new("Y", 2, 4),
		Distribution.Data.new("Z", 1, 10),
	]
	load_word_list("res://assets/word_lists/enable2k.txt")
