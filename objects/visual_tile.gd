class_name VisualTile extends TextureButton

const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")

signal removed()
signal placed(tile_data:int)

var dragging:int = 0
var data:int = 0:
	set(new):
		var old:int = data
		data = new
		_update_display()
		if old != new:
			if TD.is_empty(data):
				removed.emit()
			else:
				if animation_tree:
					var state_machine:AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
					state_machine.travel(&"inactive")
				placed.emit(data)

var is_copy:bool = false
@onready var animation_tree:AnimationTree = find_child("AnimationTree")

func _ready() -> void:
	_update_display()

func _dropped(_node:Node) -> void:
	var mock_ui = find_parent("MockUI")
	if dragging:
		data = dragging
		dragging = 0
		mock_ui.child_exiting_tree.disconnect(_dropped)

func _get_drag_data(at_position: Vector2) -> Variant:
	if TD.get_temporary(data) and data > 0:
		dragging = data
		data = 0
		var copy:VisualTile = VISUAL_TILE.instantiate()
		copy.data = dragging
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
	%Letter.text = TD.get_letter(data)
	%Points.text = str(TD.get_points(data))
	animation_tree.placed = !empty and temporary
	animation_tree.submitted = !empty and !temporary
	animation_tree.is_copy = is_copy
