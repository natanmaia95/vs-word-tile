class_name VisualTile extends TextureButton

const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")

@warning_ignore("unused_signal")
signal removed()
signal placed(tile:Tile)

var dragging:Tile
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

func _ready() -> void:
	_update_display()
	find_parent("MockUI").child_exiting_tree.connect(_dropped)

func _dropped(_node:Node) -> void:
	var mock_ui = find_parent("MockUI")
	if dragging:
		tile = dragging
		dragging = null
		mock_ui.child_exiting_tree.disconnect(_dropped)

func _get_drag_data(at_position: Vector2) -> Variant:
	if not (tile and [Tile.Placement.TEMPORARY, Tile.Placement.IN_HAND].has(tile.placement)):
		return null
	
	dragging = tile
	tile = null
	var copy:VisualTile = VISUAL_TILE.instantiate()
	copy.tile = dragging
	copy.offset_transform_enabled = true
	copy.offset_transform_position_ratio = -Vector2(.5,.5)
	copy.is_copy = true
	#var starting_position:Vector2 = copy.offset_transform_position
	#var ending_position:Vector2 = -size/2.;
	#create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE).tween_method(func(value:Variant) -> void:
		#if is_instance_valid(copy):
			#copy.offset_transform_position = lerp(starting_position, ending_position, value)
	#, 0., 1., .3)
	set_drag_preview(copy)
	return self


func _drop_data(_at_position: Vector2, drop_data: Variant) -> void:
	if not tile:
		drop_data.removed.emit()
	else:
		if drop_data.dragging.placement == Tile.Placement.IN_HAND:
			drop_data.tile = tile
		drop_data.placed.emit(tile)
	placed.emit(drop_data.dragging)
	drop_data.dragging = null

func _can_drop_data(_at_position: Vector2, drop_data: Variant) -> bool:
	if self == drop_data:
		return false
	return drop_data is VisualTile and (not tile or tile.is_empty() or tile.placement == Tile.Placement.TEMPORARY)

func _update_display() -> void:
	if not is_node_ready():
		return
	%Letter.text = tile.letter if tile else ""
	%Points.text = str(tile.points) if tile else ""
	animation_tree.placement = int(tile.placement) if tile else 0 # I hate this, godot doesn't like a nicer way though.
	animation_tree.is_copy = is_copy if tile else false
