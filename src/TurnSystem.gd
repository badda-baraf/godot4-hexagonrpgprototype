extends Node

enum TURN {PLAYER,ENEMY}
var currentTurn = TURN.PLAYER
var enemiesParent
var playerParent

@onready var winScreen = preload("res://Win.tscn")
@onready var loseScreen = preload("res://Lose.tscn")
@onready var actUi = load("res://ActUi.tscn")
var enemies 
var players 
var manuallyEnded = false
var lastPosition
var lastSelectedUnit:CharacterUnit
func _input(event):
	if event.is_action_pressed("end"):
		if Game.state != Game.STATE.CHOOSING:
			manuallyEnded = true
#		await skip_turn()
#		next_turn()
	if event.is_action_pressed("cancel"):
		await cancel()
	if event.is_action_pressed("wait"):
		await wait()
		Game.finishedAction.emit()
		check_turn()
	if event.is_action_pressed("act"):
		if Game.focusedCharacter is CharacterUnit:
			if !Game.focusedCharacter.acted and !Game.focusedCharacter.defeated and Game.focusedCharacter.unitObject.get_unit_resource() in Game.activeUnitsResouces:
#				Game.currentCursor.set_physics_process(false)
				await act()
#				Game.currentCursor.set_physics_process(true)
				Game.finishedAction.emit()
	if event.is_action_pressed("defend"):
		if Game.focusedCharacter is CharacterUnit:
			if !Game.focusedCharacter.acted and !Game.focusedCharacter.defeated and Game.focusedCharacter.unitObject.get_unit_resource() in Game.activeUnitsResouces:
				await defend()
				Game.finishedAction.emit()
				check_turn()
	if event.is_action_pressed("move"):
			if Game.focusedCharacter != null:
				if !Game.focusedCharacter.acted and !Game.focusedCharacter.defeated and Game.focusedCharacter.unitObject.get_unit_resource() in Game.activeUnitsResouces:
					Game.state = Game.STATE.CHOOSING
					await move()
					Game.state = Game.STATE.BATTLE
					Game.finishedAction.emit()
					check_turn()


func skip_turn():
	pass

func cancel():
	if  $"../CanvasLayer/ActUi".is_visible_in_tree():
		$"../CanvasLayer/ActUi".hide()
		$"../CanvasLayer/ActUi".clear_ui()
		Game.hide_ui.emit()
		Game.actUi.hide()
	if !lastPosition == null and  !lastSelectedUnit == null:
		lastSelectedUnit.position = lastPosition
		lastSelectedUnit.dehighlight_tiles()
		lastSelectedUnit.acted = false

func move():
	var subject:CharacterUnit = Game.focusedCharacter
	lastSelectedUnit = subject
	lastPosition = subject.position
	subject.highlight_tiles()
	var tiles = subject.get_traversible_tiles(subject.position)
	while(true):
		await Game.currentCursor.selectedTile
		if !Game.currentCursor.is_focused_on_unit() and Game.currentTilemap.local_to_map(Game.currentCursor.position) in tiles:
			subject.dehighlight_tiles()
			var tile = Game.currentTilemap.local_to_map(Game.currentCursor.position)
			subject.position = Game.currentTilemap.map_to_local(tile)
			subject.acted = true
			break
		else:
			print_debug("unit is here")
	


func wait():
	print_debug(Game.focusedCharacter)


func act():
	Game.hide_ui.emit()
	var au = $"../CanvasLayer/ActUi"
	if !au == null:
		au.show()
	#	add_child(au)
		au.populate_ui(Game.focusedCharacter)
		await Game.chosenSkill
		au.clear_ui()
		print_debug("finished skill")
		au.hide()


func defend():
	pass

func get_turn():
	return currentTurn

func set_turn(value:TURN):
	currentTurn = value


func switch_turn():
	match get_turn():
		TURN.PLAYER:
			
			set_turn(TURN.ENEMY)
		TURN.ENEMY:
			
			set_turn(TURN.PLAYER)
		


func run_turn():
	match get_turn():
		TURN.PLAYER:
			player_turn()
		TURN.ENEMY:
			enemy_turn()

func player_turn():
	print_debug("players turn")
	for i in get_parent().get_node("players").get_children():
		i.acted = false
	var avaliableUnits = []
	for i in Game.currentPlayerNodes:
		if i.defeated == false:
			avaliableUnits.append(i)
#	for i in get_parent().get_node("players").get_children():
	for i in avaliableUnits:
#		i.acted = false
		if manuallyEnded == true:
			break
#			next_turn()
		await Game.finishedAction
		Game.selectedUnit = null
	next_turn()

func next_turn():
	print_debug("next turn")
	manuallyEnded = false
	await switch_turn()
	await check_turn()
	run_turn()


func all_defeated(array):
	var allDefeated = true
	var defeated = []
	for i in array:
		if i.unitObject.defeated == false:
			allDefeated = false
			defeated.append(i)
			return false
	return allDefeated


func check_turn():
	var enemies = get_parent().get_node("enemies").get_children()
	var players = get_parent().get_node("players").get_children()
	if !enemies.is_empty() and !players.is_empty():
		if all_defeated(enemies):
			win()
		if all_defeated(players):
			lose()

func win():
	print_debug("You win")
	get_tree().change_scene_to_packed(winScreen)

func lose():
	print_debug("You lose!")
	get_tree().change_scene_to_packed(loseScreen)

func enemy_turn():
	print_debug("enemies turn")
	for i in get_parent().get_node("players").get_children():
			i.acted = false
	for i in get_parent().get_node("enemies").get_children():
		check_turn()
		await i._run_ai()
		i.acted = true
		print_debug(i,"acted")
	next_turn()
