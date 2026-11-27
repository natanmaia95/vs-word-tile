class_name Tile extends RefCounted

## Just thinking through this

enum Placement {NULL, IN_HAND, TEMPORARY, SUBMITTED}

var letter:String = ""
var points:int = 0
var placement:Placement = Placement.NULL
var coord:Vector2i = Vector2i.ZERO
