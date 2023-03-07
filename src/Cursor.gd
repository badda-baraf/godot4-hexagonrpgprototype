extends Area2D
class_name Cursor

#var velocity = Vector2(0,0)
const TILESIZE = 75
var tm:TileMap

@onready var ray:RayCast2D = $RayCast2D
signal selectedTile

func _on_area_entered(body):
	if body is CharacterUnit:
		Game.focusedCharacter = body
		print_debug(body)
		body.highlight_tiles()
		if body.unitObject.get_unit_resource() in Game.activeUnitsResouces.keys():
			print_debug("acted status is ", body.acted)
	#	Game.focusedEquip = equipableObject
		Game.show_ui.emit()


func _on_area_exited(body):
#	if Game.state != Game.STATE.CHOOSING:
	Game.focusedCharacter.dehighlight_tiles()
	Game.hide_ui.emit()
	Game.focusedCharacter = null
	print_debug(Game.focusedCharacter)




func _input(event):
	if event.is_action_pressed("act"):
		selectedTile.emit()
		if Game.focusedCharacter !=null:
			await set_selected_unit()
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	next_tile(direction)



func next_tile(direction):

	var currentTile = get_tile_cord()

	var nextTile = currentTile + Vector2i(direction)
	if direction.x != 0 and direction.y != 0:
		nextTile = Vector2i(currentTile.x+direction.x,currentTile.y + direction.y)
	position = Game.currentTilemap.map_to_local(nextTile)
	
	


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




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position.snapped(Vector2.ONE *TILESIZE)
	ray.target_position = input_direction * TILESIZE/2
	
	var tile = get_tile_cord()
