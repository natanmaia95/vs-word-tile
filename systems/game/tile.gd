class_name Tile extends Resource

## Just thinking through this

enum Placement {NULL, IN_HAND, TEMPORARY, SUBMITTED}

@export var letter:String = "":
	set(new):
		letter = new
		changed.emit()
		
@export var points:int = 0:
	set(new):
		points = new
		changed.emit()
		
@export var placement:Placement = Placement.NULL:
	set(new):
		placement = new
		changed.emit()

func is_empty() -> bool:
	return placement == Placement.NULL or letter.length() == 0

func _to_string() -> String:
	return "[{0},{1},{2}]".format([letter,points,Placement.find_key(placement)])
