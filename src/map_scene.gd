extends Node2D

@onready var tileMap:TileMap = $TileMap
@onready var cursor:Cursor = $Cursor
enum MODE {EXPLORE,FIGHT}
@export var mode = MODE.FIGHT
var unitScene = preload("res://CharacterUnitBase.tscn")
@export var enemyData = [{"res://Resources/Units/test_unit3.tres":"res://Resources/test_equip.tres"},{"res://Resources/Units/test_unit2.tres":"res://Resources/test_equip.tres"},{"res://Resources/Units/test_unit.tres":"res://Resources/test_equip.tres"}]
@export var enemies = {Vector2i(14,2):enemyData[0],Vector2i(4,5):enemyData[1],Vector2i(10,7):enemyData[2]}
@onready var turnSystem = $TurnSystem
func get_mode():
	return mode


func _ready():
	$CanvasLayer/Control2.hide()
	print_debug("tilemap size is:" + str(tileMap))
	match(get_mode()):
		MODE.EXPLORE:
			prepare_explore()
		MODE.FIGHT:
			await prepare_fight()
			turnSystem.run_turn()

func prepare_fight():
	#get starting placement layer tiles,put them in array. and then hide them
	tileMap.get_used_cells(4)
	for i in enemies:
		var newUnit = unitScene.instantiate()
		$enemies.add_child(newUnit)

		newUnit.position = tileMap.map_to_local(i)
		var enemyDict = enemies[i]
		print_debug(enemyDict)
		newUnit.unitObject.unitResource = load(enemyDict.keys()[0])
		newUnit.equipableObject.unitResource = load(enemyDict.values()[0])


	for i in Game.activeUnits:
#	for i in range(3):
		var newUnit = unitScene.instantiate()
		print_debug("place so and so")
		await cursor.selectedTile
		$players.add_child(newUnit)
		newUnit.position = tileMap.map_to_local(cursor.get_tile_cord())
		newUnit.unitObject.unitResource = load(i)
		print_debug("blanks position is at", " ", str(cursor.get_tile_cord()))
	print_debug("finished placement")




func prepare_explore():
	pass
