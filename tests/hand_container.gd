extends HBoxContainer
var game:ScrabbleGame:
	get():
		return find_parent("MockUI").game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.hand_changed.connect(_update_hand)
	_update_hand(game.hand)

func _update_hand(hand:Array[int]) -> void:
	for i:int in range(get_child_count()):
		var visual_tile:VisualTile = get_child(i)
		if hand.size() > i:
			visual_tile.data = hand[i]
		else:
			visual_tile.data = 0
		
