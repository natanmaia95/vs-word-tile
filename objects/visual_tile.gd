class_name VisualTile extends TextureButton

class DropData:
	var coord:Vector2i
	var data:int

const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")

signal removed()
signal placed(tile_data:int)

var dragging:int = 0
@onready var animation_tree:AnimationTree = find_child("AnimationTree")
var data:int = 0:
	set(new):
		var old:int = data
		data = new
		_update_display()
		if old != new:
			if TD.is_empty(data):
				removed.emit()
			else:
				placed.emit(data)

func _ready() -> void:
	#mouse_entered.connect(hover.bind(true))
	#mouse_exited.connect(hover.bind(false))
	_update_display()

#func hover(on:bool) -> void:
	#animation_tree.hover = on

func _dropped(node:Node) -> void:
	var mock_ui = find_parent("MockUI")
	#if node = dragging:
	if dragging:
		data = dragging
		dragging = 0
		mock_ui.child_exiting_tree.disconnect(_dropped)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if TD.get_temporary(data) and data > 0:
		dragging = data
		data = 0
		var copy:VisualTile = VISUAL_TILE.instantiate()
		print(dragging)
		copy.data = dragging
		copy.offset_transform_enabled = true
		#copy.offset_transform_position = -at_position
		copy.offset_transform_position_ratio = -Vector2(.5,.5)
		find_parent("MockUI").child_exiting_tree.connect(_dropped)
		set_drag_preview(copy)
		return self
	return null


func _drop_data(_at_position: Vector2, drop_data: Variant) -> void:
	var new_data = drop_data.dragging
	drop_data.data = data
	data = new_data
	drop_data.dragging = 0

func _can_drop_data(_at_position: Vector2, drop_data: Variant) -> bool:
	return drop_data is VisualTile and (TD.is_empty(data) or TD.get_temporary(data))

func _update_display() -> void:
	if not is_node_ready():
		return
	var empty = TD.is_empty(data)
	var temporary = TD.get_temporary(data)
	%LblLetter.text = TD.get_letter(data)
	animation_tree.placed = !empty and temporary
	animation_tree.submitted = !empty and !temporary
