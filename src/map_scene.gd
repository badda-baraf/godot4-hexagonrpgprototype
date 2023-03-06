extends Node2D

@onready var tileMap:TileMap = $TileMap
@onready var placementMap:TileMap = $InitalPlacements

@onready var highlightMap = $HighlightTileMap


@onready var cursor:Cursor = $Cursor
enum MODE {EXPLORE,FIGHT}
@export var mode = MODE.FIGHT
var unitScene = preload("res://CharacterUnitBase.tscn")

@export var enemyData = [{"res://Resources/Units/test_unit4.tres":"res://Resources/test_equip.tres"},{"res://Resources/Units/test_unit5.tres":"res://Resources/test_equip.tres"},{"res://Resources/Units/test_unit6.tres":"res://Resources/test_equip.tres"}]
@export var enemies = {Vector2i(14,2):enemyData[0],Vector2i(4,5):enemyData[1],Vector2i(10,7):enemyData[2]}
@export var enemiesJson:String = "res://prototype_level_data_placements.json"
@export var enemiesJ:JSON
@onready var turnSystem = $TurnSystem
@export var enemyColor:Color
var enemyDict = {}
func get_mode():
	return mode


func _ready():
	print_debug(enemiesJson)
	if FileAccess.file_exists(enemiesJson):
		load_data_from_json(enemiesJson)
	$CanvasLayer/UnitData.hide()
	print_debug("tilemap size is:" + str(tileMap))
	Game.currentTilemap = tileMap
	Game.currentHighlightmap = highlightMap
	Game.currentCursor = cursor
	Game.canvasLayer = $CanvasLayer
	match(get_mode()):
		MODE.EXPLORE:
			prepare_explore()
		MODE.FIGHT:
			await prepare_fight()
			turnSystem.run_turn()


func load_data_from_json(f):
	var file = FileAccess.open(f,FileAccess.READ)
	print_debug(file)
	var json = JSON.new()
	
	var content = json.parse_string(file.get_as_text())
	enemyDict = content



func prepare_fight():
	#get starting placement layer tiles,put them in array. and then hide them
	tileMap.get_used_cells(4)
	
	for enemy in enemyDict["enemies"]:
		print_debug(enemy)
		var newUnit = unitScene.instantiate()
		$enemies.add_child(newUnit)
		newUnit.position = tileMap.map_to_local(Vector2i(enemy["x"],enemy["y"]))
		newUnit.unitObject.unitResource = load(enemy["unit"])
		newUnit.equipableObject.unitResource = load(enemy["equip"])
		newUnit.reset_stats()

	var resourcesDict:Dictionary = Game.activeUnitsResouces
	var resourcesKeys = resourcesDict.keys()
	var resourceValues = resourcesDict.values()
	var index = 0
	#for player nodes
	while index != resourcesKeys.size():
		print_debug("place so and so")
		await cursor.selectedTile
		if !cursor.is_focused_on_unit() and cursor.get_tile_cord() in placementMap.get_used_cells(0):
			var newUnit = unitScene.instantiate()
			$players.add_child(newUnit)
			newUnit.position = tileMap.map_to_local(cursor.get_tile_cord())
			newUnit.unitObject.unitResource = resourcesKeys[index]
			if resourceValues[index] != null:
				newUnit.equipableObject.unitResource = resourceValues[index]
			newUnit.reset_stats()
			index += 1
			print_debug("blanks position is at", " ", str(cursor.get_tile_cord()))
#			cursor.ray.add_exception(newUnit)
		else:
			print_debug("Cannot place unit here")
	print_debug("finished player placements")
	placementMap.hide()
	Game.currentEnemiesNodes = $enemies.get_children()
	Game.currentPlayerNodes = $players.get_children()


func prepare_explore():
	pass
