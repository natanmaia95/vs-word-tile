class_name VisualTile extends TextureButton

const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")

@warning_ignore("unused_signal")
signal removed()
signal placed(tile:Tile)

var _dragged:Tile
var tile:Tile:
	set(new):
		var old:Tile = tile
		tile = new
		if old and old.changed.is_connected(_update_display):
			old.changed.disconnect(_update_display)
		if tile:
			tile.changed.connect(_update_display)
		_update_display()

var is_copy:bool = false
@onready var animation_tree:AnimationTree = find_child("AnimationTree")
@onready var letter_label:Label = find_child("Letter")
@onready var points_label:Label = find_child("Points")

func _ready() -> void:
	_update_display()
	find_parent("MockUI").child_exiting_tree.connect(_dropped)

func _dropped(_node:Node) -> void:
	if _dragged and _dragged.placement == Tile.Placement.DRAGGING:
		placed.emit(_dragged)
		_dragged = null

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not (tile and [Tile.Placement.TEMPORARY, Tile.Placement.IN_HAND].has(tile.placement)):
		return null
	_dragged = tile
	_dragged.placement = Tile.Placement.DRAGGING
	var copy:VisualTile = VISUAL_TILE.instantiate()
	copy.tile = _dragged
	copy.offset_transform_enabled = true
	copy.offset_transform_position_ratio = -Vector2(.5,.5)
	copy.is_copy = true
	set_drag_preview(copy)
	removed.emit()
	return _dragged

func is_hand_tile() -> bool:
	if tile:
		return tile.placement == Tile.Placement.IN_HAND
	else:
		return find_parent("HandContainer") != null

func _drop_data(_at_position: Vector2, drop_data: Variant) -> void:
	placed.emit(drop_data)

func _can_drop_data(_at_position: Vector2, drop_data: Variant) -> bool:
	if tile == drop_data or not drop_data is Tile:
		return false
	if tile and tile.placement == Tile.Placement.SUBMITTED:
		return false
	return (not tile or tile.is_empty() or is_hand_tile())

func _update_display() -> void:
	if not is_node_ready():
		return
	if not (letter_label and points_label and animation_tree):
		return
	letter_label.text = tile.letter if tile else ""
	points_label.text = str(tile.points) if tile else ""
	animation_tree.placement = int(tile.placement) if tile else 0 # I hate this, godot doesn't like a nicer way though.
	animation_tree.is_copy = is_copy if tile else false
