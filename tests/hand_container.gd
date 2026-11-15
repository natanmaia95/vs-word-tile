extends HBoxContainer
var game:ScrabbleGame:
	get():
		return find_parent("MockUI").game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.hand_changed.connect(_update_hand)
	_update_hand(game.hand)



func _update_hand(hand:Array[String]) -> void:
	for i:int in range(get_child_count()):
		var visual_tile:VisualTile = get_child(i)
		var letter:Variant = hand.get(i)
		if letter:
			visual_tile.letter = letter
			visual_tile.active = true
		else:
			visual_tile.letter = " "
			visual_tile.active = false
		
