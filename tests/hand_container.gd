extends HBoxContainer

var hand:Hand:
	set(new):
		if hand and hand.changed.is_connected(_update_display):
			hand.changed.disconnect(_update_display)
		hand = new
		hand.changed.connect(_update_display)
		_update_display()

func _ready() -> void:
	_update_display()

func _update_display() -> void:
	if not (is_node_ready() and hand):
		return
	for i:int in range(get_child_count()):
		var visual_tile:VisualTile = get_child(i)
		visual_tile.tile = hand.get_tile(i)
