class_name VisualTile extends TextureButton

const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")


signal placed(tile:String)


#@onready var animation_player:AnimationPlayer = find_child("AnimationPlayer")
@onready var animation_tree:AnimationTree = find_child("AnimationTree")

var draggable:bool = false
var swappable:bool = false
var letter : String = "" :
	set(value):
		letter = value.capitalize()
		%LblLetter.text = letter

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

func _get_drag_data(at_position: Vector2) -> Variant:
	if draggable and letter.length() > 0:
		var copy:VisualTile = VISUAL_TILE.instantiate()
		copy.copy(self)
		copy.draggable = false
		copy.offset_transform_enabled = true
		#copy.offset_transform_position = -at_position
		copy.offset_transform_position_ratio = -Vector2(.5,.5)
		set_drag_preview(copy)
		copy.active = true
		return self
	return null

func copy(tile:VisualTile) -> void:
	letter = tile.letter
	active = tile.active

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var has_letter:bool = letter.length()
	print("Dropping ",data.letter," onto me ", data.active);
	var old_letter:String = letter
	var old_active:bool = active
	letter = data.letter
	active = true
	if data.swappable and swappable: # tile in hand, swappable
		data.letter = old_letter
		data.active = old_active
	elif has_letter and active: # tile on board already and is active
		letter = old_letter
		data.active = true
	else: # placing tile on inactive board tile
		data.letter = ""
		data.active = false
		draggable = true
		swappable = true
		placed.emit(letter)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if not data is VisualTile:
		return false
	return true
	#var has_letter:bool = letter.length()
	#return not has_letter or (has_letter and swappable)
