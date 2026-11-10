extends Sprite2D


var LETTERS : Array = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split()

var game : ScrabbleGame = null



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			on_click()

func _process(_delta:float) -> void:
	var mouse_pos = get_parent().get_local_mouse_position()
	var grid_pos = BoardRenderer.local_to_grid(mouse_pos)
	var snapped_pos = BoardRenderer.grid_to_local(grid_pos)
	position = snapped_pos

func get_grid_pos() -> Vector2i:
	return BoardRenderer.local_to_grid(position)

func on_click() -> void:
	var center_pos = get_grid_pos()
	var positions = [center_pos]
	if Input.is_key_pressed(KEY_SHIFT):
		if randf() < 0.5: positions.append(center_pos + Vector2i(0,1))
		if randf() < 0.5: positions.append(center_pos + Vector2i(0,-1))
		if randf() < 0.5: positions.append(center_pos + Vector2i(1,0))
		if randf() < 0.5: positions.append(center_pos + Vector2i(-1,0))
	for pos in positions:
		place_random_tile(pos)

func place_random_tile(pos:Vector2i) -> void:
	var tile_data = 0
	var letter = LETTERS.pick_random()
	tile_data = TD.set_letter(letter, tile_data)
	if randf() < 0.2: 
		tile_data = TD.set_evil(true, tile_data)
	# add or remove
	if game.board.get_tile_data(pos) != 0:
		remove_tile(pos)
	else:
		place_tile(pos, tile_data)

func place_tile(pos:Vector2i, tile_data:int) -> void:
	game.board.set_tile_data(pos, tile_data)

func remove_tile(pos:Vector2i) -> void:
	game.board.set_tile_data(pos, 0)
