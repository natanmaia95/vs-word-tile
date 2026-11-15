class_name TileBag
extends RefCounted


## Stores tiles as letters for now
@warning_ignore("unused_private_class_variable")
var _tiles : Array[String] = []




func populate() -> void:
	_tiles.clear()
	#for letter in OfficialEnglishDistribution.LETTER_AMOUNTS.keys():
		#for _i in range(OfficialEnglishDistribution.LETTER_AMOUNTS.get(letter)):
			#_tiles.append(letter)
