class_name Draggable2D
extends Node2D

@export var drag_button : BaseButton
#@export var sub_window : ViewWindow

@export var slide_friction := 10.0

@export var smooth_drag := true

enum DragStates { IDLE, DRAGGING }
var drag_state = DragStates.IDLE

var grab_offset := Vector2.ZERO

var velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drag_button.button_down.connect(_on_drag_button_pressed)
	drag_button.button_up.connect(_on_drag_button_released)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_drag_state(delta)

func _physics_process(delta: float) -> void:
	_physics_drag_state(delta)

func _update_drag_state(delta:float) -> void:
	if drag_state == DragStates.DRAGGING:
		var old_position := global_position
		var target_position := get_global_mouse_position() - grab_offset
		if smooth_drag:
			global_position = lerp(target_position, global_position, 1.0 - (20 * delta))
		else:
			global_position = target_position
		velocity = global_position - old_position
	if drag_state == DragStates.IDLE:
		#velocity *= 1 - (0.1) processed in physics
		global_position += velocity

func _physics_drag_state(delta:float) -> void:
	if drag_state == DragStates.IDLE:
		velocity *= 1 - (slide_friction * delta)

func _on_drag_button_pressed() -> void:
	drag_state = DragStates.DRAGGING
	grab_offset = get_global_mouse_position() - global_position

func _on_drag_button_released() -> void:
	drag_state = DragStates.IDLE
	grab_offset = Vector2.ZERO
