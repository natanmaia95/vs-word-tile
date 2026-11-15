class_name VisualTile extends TextureButton

@onready var animation_player:AnimationPlayer = find_child("AnimationPlayer")

## We should make this a getter to pull from game state
#var cursor_letter:String = " "

var letter : String = " " :
	set(value):
		letter = value[0].capitalize()
		%LblLetter.text = letter

var active:bool = false:
	set(value):
		active = value
		if(active):
			animation_player.play(&"show_drop", -1, 4)
		else:
			animation_player.play(&"show", -1, -2., true)

func _ready() -> void:
	animation_player.play(&"hover_inactive", -1, -100., true)
	mouse_entered.connect(hover.bind(true))
	mouse_exited.connect(hover.bind(false))
	

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
