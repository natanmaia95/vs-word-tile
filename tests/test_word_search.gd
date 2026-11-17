extends Node2D

var distro

func _ready() -> void:
	distro = OfficialEnglishDistribution.new()
	print(distro.load_word_list())
	print(distro.word_list)
