extends Node

enum TURN {PLAYER,ENEMY}
var currentTurn = TURN.PLAYER
var enemiesParent
var playerParent

@onready var winScreen = preload("res://Win.tscn")
@onready var loseScreen = preload("res://Lose.tscn")
@onready var actUi = load("res://ActUi.tscn")
func _input(event):
	if event.is_action_pressed("wait"):
		await wait()
		Game.finishedAction.emit()
		check_turn()
	if event.is_action_pressed("act"):
		if Game.focusedCharacter is CharacterUnit:
			if !Game.focusedCharacter.acted and Game.focusedCharacter.unitObject.get_unit_resource() in Game.activeUnitsResouces:
				await act()
				Game.finishedAction.emit()
	if event.is_action_pressed("defend"):
		await defend()
		Game.finishedAction.emit()
		check_turn()
	check_turn()




func wait():
	print_debug(Game.focusedCharacter)


func act():
	var au = $"../CanvasLayer/ActUi"
	if !au == null:
		au.show()
	#	add_child(au)
		au.populate_ui(Game.focusedCharacter)
		await Game.chosenSkill
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
	for i in get_parent().get_node("players").get_children():
#		i.acted = false
		await Game.finishedAction
		Game.selectedUnit = null
	next_turn()

func next_turn():
	await switch_turn()
	await check_turn()
	run_turn()


func all_defeated(array):
	var allDefeated = true
	for i in array:
		if i.unitObject.defeated == false:
			allDefeated = false
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
		await i.run_ai()
		i.acted = true
		print_debug(i,"acted")
	next_turn()
