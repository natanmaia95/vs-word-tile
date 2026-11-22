class_name VisualTile extends TextureButton

const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")


signal placed(tile_data:int)

@onready var animation_tree:AnimationTree = find_child("AnimationTree")
var data:int = 0:
	set(new):
		data = new
		letter = TD.get_letter(data)
		print("letter set to ", letter)
		

var draggable:bool = false
var swappable:bool = false
var letter : String = "":
	set(value):
		%LblLetter.text = value.capitalize()

var active:bool = false:
	set(value):
		active = value
		if animation_tree:
			animation_tree.placed = active

func _ready() -> void:
	mouse_entered.connect(hover.bind(true))
	mouse_exited.connect(hover.bind(false))

func hover(on:bool) -> void:
	animation_tree.hover = on

func _get_drag_data(_at_position: Vector2) -> Variant:
	if draggable and data > 0:
		var copy:VisualTile = VISUAL_TILE.instantiate()
		copy.data = data
		copy.draggable = false
		copy.offset_transform_enabled = true
		#copy.offset_transform_position = -at_position
		copy.offset_transform_position_ratio = -Vector2(.5,.5)
		set_drag_preview(copy)
		copy.active = true
		return self
	return null


func _drop_data(_at_position: Vector2, drop_data: Variant) -> void:
	var has_letter:bool = letter.length()
	var old_data:int = data
	var old_active:bool = active
	data = drop_data.data
	active = true
	if drop_data.swappable and swappable: # tile in hand, swappable
		drop_data.data = old_data
		drop_data.active = old_active
	elif has_letter and active: # tile on board already and is active
		data = old_data
		drop_data.active = true
	else: # placing tile on inactive board tile
		drop_data.data = 0
		drop_data.active = false
		draggable = true
		swappable = true
		placed.emit(data)

func _can_drop_data(_at_position: Vector2, drop_data: Variant) -> bool:
	if not drop_data is VisualTile:
		return false
	return true
