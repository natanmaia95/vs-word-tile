class_name TD
## TileData


enum Type {
	NORMAL = 0, DOUBLE = 1, TRIPLE = 2
}

## Bit layout:
##  15 | 14   13   12   11 | 10   09   08 | 07   06   05   04   03   02   01   00  
## evil|      unused       |  type data   |         single letter data

const MASK_LETTER = 0b0000000011111111
const MASK_TYPE   = 0b0000011100000000
const MASK_EVIL   = 0b1000000000000000
const MASK_16BIT = 0xFFFF

const LETTER_POINT_VALUES : Dictionary[String, int] = {
	"A": 1, "B": 3, "C": 3, "D": 2, "E": 1, 
	"F": 4, "G": 2, "H": 4, "I": 1, "J": 8, 
	"K": 5, "L": 1, "M": 3, "N": 1, "O": 1, 
	"P": 3, "Q": 10, "R": 1, "S": 1, "T": 1, 
	"U": 1, "V": 4, "W": 4, "X": 8, "Y": 4, "Z": 10
}




static func points_for_letter(letter:String) -> int:
	letter = letter[0].capitalize()
	return LETTER_POINT_VALUES.get(letter, 0)




static func is_empty(tile:int) -> bool:
	return tile == 0


static func get_evil(tile:int) -> bool:
	return bool(tile & MASK_EVIL)


static func get_type(tile:int) -> Type:
	var tile_zone = (tile & MASK_TYPE) >> 8
	return tile_zone as Type


static func get_letter(tile:int) -> String:
	var letter_zone = (tile & MASK_LETTER) # 8 bits
	return char(letter_zone + 64).capitalize()


static func get_multiplier_for_type(type) -> int:
	match type:
		Type.NORMAL: return 1
		Type.DOUBLE: return 2
		Type.TRIPLE: return 3
	return 1




static func set_evil(evil:bool, tile:int) -> int:
	if evil:
		tile = tile | MASK_EVIL
	else:
		tile = tile & ~MASK_EVIL
	return tile & MASK_16BIT


static func set_type(type:Type, tile:int) -> int:
	var type_bits = int(type) << 8
	tile = (tile & ~MASK_TYPE) | type_bits
	return tile & MASK_16BIT


static func set_letter(letter:String, tile:int) -> int:
	if letter.length() != 1:
		printerr("Setting tile letter with invalid value: \'%s\'" % letter)
		letter = "?"
	var letter_bits = ord(letter[0].capitalize()) - 64
	if letter_bits > 0xFF:
		printerr("Setting tile letter with invalid value: \'%s\'" % letter)
		letter_bits = ord("?")
	tile = (tile & ~MASK_LETTER) | letter_bits
	return tile & MASK_16BIT





class Abstraction extends RefCounted:
	
	var data : int = 0
	var letter : String = ""
	var evil : bool = false
	var type : Type = Type.NORMAL
	
	
	func _init(tile_data:int) -> void:
		data = tile_data
		letter = TD.get_letter(data)
		evil = TD.get_evil(data)
		type = TD.get_type(data)
	
	func get_points_value() -> int:
		var points = TD.points_for_letter(letter)
		points *= TD.get_multiplier_for_type(type)
		if evil: points *= -1
		return points
	
	func to_int() -> int:
		data = TD.set_evil(evil, data)
		data = TD.set_letter(letter, data)
		data = TD.set_type(type, data)
		return data
