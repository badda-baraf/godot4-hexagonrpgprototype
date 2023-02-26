extends CharacterBody2D


#var velocity = Vector2(0,0)
const SPEED = 300.0
var tm:TileMap
signal selectedTile
func _input(event):
	if event.is_action_pressed("act"):
		selectedTile.emit()
		if Game.focusedCharacter !=null:
			await set_selected_unit()

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


func is_focused_on_unit():
	if Game.focusedCharacter != null:
		return true
	else:
		return false


func set_selected_unit():
	Game.selectedUnit = Game.focusedCharacter
	Game.selectedCharacter.emit()
	print_debug(Game.selectedUnit)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * 50
	move_and_slide()

#	position = get_global_mouse_position()
#	print_debug(get_tile_cord())

