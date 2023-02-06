extends Node

enum TURN {PLAYER,ENEMY}
var currentTurn = TURN.PLAYER
var enemiesParent
var playerParent

func _input(event):
	if event.is_action_pressed("wait"):
		await wait()
		Game.finishedAction.emit()
	if event.is_action_pressed("act"):
		await act()
		Game.finishedAction.emit()
	if event.is_action_pressed("defend"):
		await defend()
		Game.finishedAction.emit()

func wait():
	pass

func act():
	pass


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
	for i in Game.activeUnits:
		await Game.finishedAction
		print_debug("finsihed action")
	next_turn()

func next_turn():
	await switch_turn()
	run_turn()


func enemy_turn():
	print_debug("enemies turn")
	for i in get_parent().get_node("enemies").get_children():
		await i.run_ai()
		print_debug(i,"acted")
	next_turn()
