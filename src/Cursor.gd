extends Area2D
class_name Cursor

#var velocity = Vector2(0,0)
const TILESIZE = 75
var tm:TileMap

@onready var ray:RayCast2D = $RayCast2D
signal selectedTile





func _input(event):
	if event.is_action_pressed("act"):
		selectedTile.emit()
		if Game.focusedCharacter !=null:
			await set_selected_unit()
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	print_debug(input_direction.normalized())
	await move_next_tile(Vector2i(input_direction))


func get_tile_type():
	var tileCord = get_tile_cord()
#	print_debug(tm.get_surrounding_cells(tileCord))
	for i in range(tm.get_layers_count(),0,-1):
#		var tile = tm.get_cell_tile_data(i -1,tileCord)
		var tile = tm.get_cell_tile_data(i -1,tileCord)
		if !tile == null:
			return tile

func get_tile_cord() -> Vector2i:
	if !get_parent().get_node("TileMap") == null:
		tm = get_parent().get_node("TileMap")
		var vec = tm.local_to_map(position)
		return vec
	else:
		return Vector2i(0,0)

func get_tile_cord_spec(pos) -> Vector2i:
	if !get_parent().get_node("TileMap") == null:
		tm = get_parent().get_node("TileMap")
		var vec = tm.local_to_map(position)
		return vec
	else:
		return Vector2i(0,0)

func is_focused_on_unit():
	if Game.focusedCharacter != null:
		return true
	else:
		return false


func set_selected_unit():
	Game.selectedUnit = Game.focusedCharacter
	Game.selectedCharacter.emit()
	print_debug(Game.selectedUnit)

func move_next_tile(toNext):
	print_debug(toNext)
	var currentPosition = position
	var currentTile = Game.currentTilemap.local_to_map(currentPosition)
	var nextTile = currentTile + Vector2i(ceil(toNext.x),ceil(toNext.y))
	position = Game.currentTilemap.map_to_local(nextTile)


