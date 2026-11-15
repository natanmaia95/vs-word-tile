class_name VisualTile extends TextureButton

signal placed(tile:String)

@onready var animation_player:AnimationPlayer = find_child("AnimationPlayer")

## We should make this a getter to pull from game state
#var cursor_letter:String = " "
const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")

var draggable:bool = false
var swappable:bool = false
var letter : String = "" :
	set(value):
		letter = value.capitalize()
		%LblLetter.text = letter

var active:bool = false:
	set(value):
		if active != value and is_node_ready():
			if(value):
				animation_player.play(&"show_drop", -1, 4)
			else:
				animation_player.play(&"show", -1, -2., true)
		active = value

func _ready() -> void:
	animation_player.play(&"hover_inactive", -1, -100., true)
	mouse_entered.connect(hover.bind(true))
	mouse_exited.connect(hover.bind(false))
	if(active):
		animation_player.play(&"show_drop", -1, 4)
	else:
		animation_player.play(&"show", -1, -2., true)
	

func hover(on:bool) -> void:
	if animation_player.is_playing() and not animation_player.current_animation.begins_with("hover"):
		return
	if active:
		return
	else:
		if on:
			animation_player.play(&"hover_inactive", -1, 8)
		else:
			animation_player.play(&"hover_inactive", -1, -2., true)

func _get_drag_data(at_position: Vector2) -> Variant:
	if draggable and letter.length() > 0:
		var copy:VisualTile = VISUAL_TILE.instantiate()
		copy.copy(self)
		copy.draggable = false
		copy.offset_transform_enabled = true
		copy.offset_transform_position = -at_position
		active = false
		set_drag_preview(copy)
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
		placed.emit(letter)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if not data is VisualTile:
		return false
	return true
	#var has_letter:bool = letter.length()
	#return not has_letter or (has_letter and swappable)
