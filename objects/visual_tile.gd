class_name VisualTile extends Control

@onready var animation_player:AnimationPlayer = find_child("AnimationPlayer")

var letter : String = " " :
	set(value):
		letter = value[0].capitalize()
		%LblLetter.text = letter

func _ready() -> void:
	animation_player.play(&"show_drop", -1, 2.)

func remove() -> void:
	animation_player.play(&"show", -1, -2., true)
	await animation_player.animation_finished
	queue_free()
