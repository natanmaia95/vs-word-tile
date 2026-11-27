class_name VisualTile extends TextureButton

const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")

signal removed()
signal placed(tile:Tile)

var dragging:Tile
var tile:Tile:
	set(new):
		var old:Tile = tile
		tile = new
		#if old and old.changed.is_connected(_update_display):
			#old.changed.disconnect(_update_display)
		#if new:
			#new.changed.connect(_update_display)
		_update_display()
		if tile and old != new:
			if tile.is_empty():
				removed.emit()
			else:
				if animation_tree:
					var state_machine:AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
					state_machine.travel(&"inactive")
				placed.emit(tile)

var is_copy:bool = false
@onready var animation_tree:AnimationTree = find_child("AnimationTree")

func _ready() -> void:
	_update_display()

func _dropped(_node:Node) -> void:
	var mock_ui = find_parent("MockUI")
	if dragging:
		tile = dragging
		dragging = null
		mock_ui.child_exiting_tree.disconnect(_dropped)

func is_draggable() -> bool:
	if not tile or tile.is_empty():
		return false
	return [Tile.Placement.TEMPORARY, Tile.Placement.IN_HAND].has(tile.placement)
func _get_drag_data(at_position: Vector2) -> Variant:
	if !is_draggable():
		return null
	
	dragging = tile
	tile = null
	var copy:VisualTile = VISUAL_TILE.instantiate()
	copy.tile = dragging
	copy.offset_transform_enabled = true
	copy.offset_transform_position = -at_position
	copy.is_copy = true
	var starting_position:Vector2 = copy.offset_transform_position
	var ending_position:Vector2 = -size/2.;
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE).tween_method(func(value:Variant) -> void:
		if is_instance_valid(copy):
			copy.offset_transform_position = lerp(starting_position, ending_position, value)
	, 0., 1., .3)
	find_parent("MockUI").child_exiting_tree.connect(_dropped)
	set_drag_preview(copy)
	return self


func _drop_data(_at_position: Vector2, drop_data: Variant) -> void:
	var new_data = drop_data.dragging
	drop_data.tile = tile
	tile = new_data
	drop_data.dragging = null

func _can_drop_data(_at_position: Vector2, drop_data: Variant) -> bool:
	return drop_data is VisualTile and (not tile or tile.is_empty() or tile.placement == Tile.Placement.TEMPORARY)

func _update_display() -> void:
	if not is_node_ready() or not tile:
		return
	%Letter.text = tile.letter
	%Points.text = str(tile.points)
	animation_tree.placement = int(tile.placement) # I hate this, godot doesn't like a nicer way though.
	animation_tree.is_copy = is_copy
