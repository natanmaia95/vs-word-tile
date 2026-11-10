class_name BoardRenderer
extends Node2D


static func grid_to_local(pos:Vector2i) -> Vector2:
	return Vector2(pos * 32)

static func local_to_grid(pos:Vector2) -> Vector2i:
	return (pos / 32.0).round()



const PACKED_TILE := preload("res://objects/visual_tile.tscn")
var LETTERS : Array = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split()

var tile_nodes := {}
var game : ScrabbleGame



func initialize(game_in:ScrabbleGame) -> void:
	game = game_in
	game.board.updated_tiles.connect(on_updated_tiles)
	
	if %test_cursor:
		%test_cursor.game = game



func on_updated_tiles(positions:Array[Vector2i]) -> void:
	for pos in positions:
		var tile_data = game.board.get_tile_data(pos)
		
		# empty twice?
		if not tile_nodes.has(pos) and tile_data == 0: continue
		
		# tile removed
		if tile_nodes.has(pos) and tile_data == 0:
			animate_tile_removed(pos, tile_data)
			continue
		
		# tile added
		if not tile_nodes.has(pos) and tile_data != 0:
			animate_tile_placed(pos, tile_data)
			continue
		
		# tile changed? state changed? edge cases ig
		if tile_nodes.has(pos) and tile_data != 0:
			animate_tile_changed(pos, tile_data)
			continue
		
		print_debug("missed all cases?", pos, tile_data)
	pass




func animate_tile_placed(pos:Vector2i, tile_data:int) -> void:
	var new_tile : Node2D = PACKED_TILE.instantiate()
	new_tile.letter = TD.get_letter(tile_data)
	new_tile.position = BoardRenderer.grid_to_local(pos)
	add_child(new_tile)
	tile_nodes[pos] = new_tile
	# animate entry
	new_tile.scale = Vector2.ONE * 1.3
	new_tile.rotation_degrees = 20
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.set_parallel()
	tween.tween_property(new_tile, "scale", Vector2.ONE, 0.3)
	tween.tween_property(new_tile, "rotation", 0, 0.3)


func animate_tile_removed(pos:Vector2i, _tile_data:int) -> void:
	var tile = tile_nodes.get(pos)
	tile_nodes.erase(pos)
	# animate exit
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.set_parallel()
	tween.tween_property(tile, "scale", Vector2.ONE*2, 0.5)
	tween.tween_property(tile, "modulate:a", 0, 0.5)
	tween.set_parallel(false)
	tween.tween_callback(tile.queue_free)


func animate_tile_changed(pos:Vector2i, tile_data:int) -> void:
	# if it becomes evil, then an evil was placed here; delete the old one
	if TD.get_evil(tile_data):
		var tile = tile_nodes.get(pos)
		tile_nodes.erase(pos)
		tile.queue_free()
		animate_tile_placed(pos, tile_data) # place evil
		return
	# otherwise just change values raw idk
	# TODO:
