extends GridContainer
const VISUAL_TILE = preload("uid://ds8omu6g4wqyo")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for y in range(columns):
		for x in range(columns):
			add_child(VISUAL_TILE.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
