extends Area2D
class_name CharacterUnit
@onready var animationPlayer:AnimationPlayer = $AnimationPlayer
@onready var sprite2d:Sprite2D = $Sprite
@onready var fsm:StackStateMachine = $AI
@onready var unitObject:UnitObject = $UnitObject
@onready var equipableObject:EquipableObject = $EquipableObject
@onready var defaultStateNode = $States/DefaultState
@onready var crisisStateNode = $States/CrisisState
@onready var agressiveStateNode = $States/SupportState
@export var enemyColor:Color
var defaultState:Callable

var crisisState:Callable

var agressiveState:Callable
var acted = false
var defeated = false
var skillIds = []
var agrrod:bool = true
func _ready():
	if get_parent().name == "enemies":
		modulate = enemyColor
	print_debug(sprite2d.texture)
	area_entered.connect(on_hover)
	area_exited.connect(on_hover_exited)
	reset_stats()
	unitObject.currentStamina = unitObject.unitResource.stamina
	defaultState = defaultStateNode._run
	print_debug(defaultState)
	crisisState = crisisStateNode._run
	agressiveState = agressiveStateNode._run
	setup_ai()


	fsm.push_state(defaultState)
	skillIds = get_unlocked_skills_ids()


func setup_ai():
	var possibleDefaultState = unitObject.unitResource.defaultAiState
	var possibleCrisistState = unitObject.unitResource.crisisAiState
	var possibleAggresiveState = unitObject.unitResource.aggresiveAiState
	if possibleDefaultState != null:
		defaultState = possibleDefaultState.new()._run
	if possibleCrisistState != null:
		crisisState = possibleCrisistState.new()._run
	if possibleAggresiveState != null:
		agressiveState = possibleAggresiveState.new()._run
		


func _check_ai():
	fsm.push_state(defaultState)
	if unitObject.currentStamina <= unitObject.maxStamina/3:
		fsm.push_state(crisisState)
	if agrrod:
		fsm.push_state(agressiveState)
	

func _run_ai():
	reset_stats()
	await fsm.get_state().call(self)
	print_debug(fsm.get_state())

func reset_stats():
	print_debug(unitObject.unitResource.unitSpritePath)
	var unitSprite = load(unitObject.unitResource.unitSpritePath)
	sprite2d.texture = unitSprite
	unitObject.currentDefense = unitObject.get_defense()
	unitObject.currentSpeed = unitObject.get_speed()
	unitObject.currentFocus = unitObject.get_focus()
	unitObject.currentStrength = unitObject.get_strength()

func auto_move():
	var movement = unitObject.unitResource.movement
	var tilePos = Game.currentTilemap.local_to_map(position)
	var newPosition = Vector2i(tilePos.x +1 ,tilePos.y + 1)
	
	position = Game.currentTilemap.map_to_local(newPosition)

func move_to_target(pos):
	# later put a star for getting animation points
	
	var newPositionTileTarget =  Game.currentTilemap.local_to_map(pos)
	newPositionTileTarget = Vector2i()
	
	position = Game.currentTilemap.map_to_local(newPositionTileTarget)
	pass




func move_unil_unit():
	var oppositionArray
	if get_parent().name == "enemies":
		oppositionArray = Game.currentPlayerNodes
	if get_parent().name == "players":
		pass
	for i in oppositionArray:
		pass


func move_until_unit_old():
	if self in Game.currentEnemiesNodes:
		var playerUnits:Array = Game.currentPlayerNodes
		var closestUnit:CharacterUnit
		var closestTile:Vector2
		var tilePosition:Vector2 = Vector2(Game.currentTilemap.local_to_map(position))
		for i in playerUnits:
			var unitPositionTile:Vector2 = Vector2(Game.currentTilemap.local_to_map(i.position))
			if closestUnit == null:
				closestUnit = i
				closestTile = Vector2(Game.currentTilemap.local_to_map(closestUnit.position))
			else:
				if tilePosition.distance_squared_to(unitPositionTile) > tilePosition.distance_squared_to(closestTile):
					closestUnit = i
					closestTile = Vector2(Game.currentTilemap.local_to_map(closestUnit.position))
		print_debug(closestTile,closestUnit)
#		if closestTile in get_traversible_tiles(position):
		if closestTile:
			var tiles = Game.currentTilemap.get_surrounding_cells(closestTile)
			print_debug(tiles)
			var targetPos 
			for i in tiles:
				var totalUnits = Game.currentEnemiesNodes + Game.currentPlayerNodes
				for z in totalUnits:
					print_debug(i,z.position)
#					if Game.currentTilemap.map_to_local(i) != z.position:
					if i == Game.currentTilemap.local_to_map(z.position):
						print_debug("faliure")
#					if i != Game.currentTilemap.local_to_map(z.position):
					else:
						targetPos = i
						print_debug(targetPos)
						position = Game.currentTilemap.map_to_local(targetPos)
						break
	get_closest_unit_and_position_from_given_position(position)







func move_to_closest_unit():
		var units = get_traversible_units(position)
		print_debug("can move")
		var unitPoints = units.values()
		unitPoints.sort_custom(func(a, b): return a[0] < b[0])
		print_debug(unitPoints)
		var points = get_path_to_unit(units.find_key(unitPoints[0]))
		print_debug(" to get to the closest unit", str(self), "will go to cord: ", points[-1] , "at real: ", Game.currentTilemap.map_to_local(points[-1]))
		position = Game.currentTilemap.map_to_local(points[0])

func get_path_to_position(pos:Vector2i):
	var astar = AStarGrid2D.new()
	astar.size = Game.currentTilemap.get_used_rect().size
	astar.cell_size = Vector2i(32,32)
	astar.update()
	return astar.get_point_path(position,pos)

func get_best_skill() -> Skill:
	var s:Skill = Game.get_skill_by_id(skillIds[0])
	var closesUnitDict = get_closest_unit_and_position_from_given_position(position)
	var farthestUnitDict = get_farthest_unit_and_position()
	for i in skillIds:
		var potentialSkill = Game.get_skill_by_id(i)
		if is_skill_in_range(potentialSkill,closesUnitDict.keys()[0]) and unitObject.currentStamina > potentialSkill.chargeCost:
			s = potentialSkill
		if potentialSkill.chargeCost < s.chargeCost:
			s = potentialSkill
		if is_skill_in_range(potentialSkill,farthestUnitDict.keys()[0]):
			s = potentialSkill
	print_debug("the chosen best skill is: ", s)
	return s

func is_skill_in_range(skill:Skill,unit:CharacterUnit):
	var astar = AStarGrid2D.new()
	astar.size = Game.currentTilemap.get_used_rect().size
	astar.cell_size = Vector2i(32,32)
	astar.update()
	var skillRange = Rect2i(Vector2i(position),Vector2i(skill.range,skill.range))
	if skillRange.has_point(unit.position):
		return true
	else:
		return false

func get_traversible_units(startingPos):
	var dict = {}
	var trav = get_traversible_tiles(startingPos)
	var allUnits = Game.currentEnemiesNodes + Game.currentPlayerNodes
	if !trav.is_empty():
		for i in allUnits:
			if i != self:
				var unitPos = Game.currentTilemap.local_to_map(i.position)
				if unitPos in trav:
					dict[i] = unitPos
#	print_debug(dict)
	return dict

func highlight_tiles():
	if Game.state != Game.STATE.CHOOSING:
		for i in get_traversible_tiles(position):
			Game.currentHighlightmap.set_cell(0,i,0,Vector2i(0,2),1)

func dehighlight_tiles():
	if Game.state != Game.STATE.CHOOSING:
		Game.currentHighlightmap.clear_layer(0)

func get_path_to_unit(unit:CharacterUnit):
	var astar = AStarGrid2D.new()
	astar.size = Game.currentTilemap.get_used_rect().size
	astar.cell_size = Vector2i(32,32)
	astar.update()
	return astar.get_id_path(Game.currentTilemap.local_to_map(position),Game.currentTilemap.local_to_map(unit.position))

func get_closest_unit_and_position_from_given_position(pos):
	var dict = get_traversible_units(pos)
#	var dict = get_path_until_unit_offensive_dict()
	var newDict = {}
#	for i in get_traversible_units(position):
	for i in dict:
		if i != self:
			var vec = Vector2(dict[i]) 
			var distance = vec.distance_squared_to(pos)
			newDict[i] = dict[i]
			if newDict[i] is float and distance < newDict[i]:
				newDict.clear()
				newDict[i] = dict[i]
#	print_debug(newDict)
	return newDict

func get_farthest_unit_and_position():
	var dict = get_traversible_units(position)
	var newDict = {}
	for i in get_traversible_units(position):
		var vec = Vector2(dict[i]) 
		var distance = vec.distance_squared_to(position)
		newDict[i] = dict[i]
		if newDict[i] is float and distance > newDict[i]:
			newDict.clear()
			newDict[i] = dict[i]
#	print_debug(newDict)
	return newDict

func get_allies():
	var arr = []
	if !get_parent() == null:
		arr.append_array(get_parent().get_children())
#	print_debug(arr)
	return arr

func get_traversible_tiles(startingPos):
	var tiles = []
	if !Game.currentTilemap == null:
		var currentTilePos = Game.currentTilemap.local_to_map(startingPos)
		for i in range(unitObject.get_unit_resource().movement):
			tiles.append_array(Game.currentTilemap.get_surrounding_cells(Vector2i(currentTilePos.x + i,currentTilePos.y)))
			tiles.append_array(Game.currentTilemap.get_surrounding_cells(Vector2i(currentTilePos.x - i,currentTilePos.y)))
			tiles.append_array(Game.currentTilemap.get_surrounding_cells(Vector2i(currentTilePos.x,currentTilePos.y - i)))
			tiles.append_array(Game.currentTilemap.get_surrounding_cells(Vector2i(currentTilePos.x,currentTilePos.y + i)))
#	print_debug(tiles)
	return tiles




func on_hover(body:Node2D):
	pass
#	if body is Cursor:
##		Game.focusedCharacter = self
#		highlight_tiles()
#		if unitObject.get_unit_resource() in Game.activeUnitsResouces.keys():
#			print_debug("acted status is ", acted)
#	#	Game.focusedEquip = equipableObject
#		Game.show_ui.emit()

func on_hover_exited(body:Node2D):
	pass
#	if Game.state != Game.STATE.CHOOSING:
#		dehighlight_tiles()
#	Game.hide_ui.emit()
#	Game.focusedCharacter = null
#	Game.focusedEquip = null

func _on_clicked():
	print_debug(unitObject.unitResource)
	print_debug(equipableObject.unitResource)

#glue node
func is_valid_weilder():
	var ids:Array = equipableObject.get_equiplable_ids()
	var weilder:UnitObject = unitObject
	if ids.is_empty() or weilder.get_unit_resource().id in ids:
		return true
	else:
		return false

func set_animation(animationName):
	if animationPlayer.is_playing():
		animationPlayer.stop()
	animationPlayer.play(animationName)

func get_unlocked_skills_ids():
	var skills = []
	var possibleSkills = unitObject.get_unlocked_skills_ids()
	if is_valid_weilder():
		possibleSkills.append_array(equipableObject.get_unlocked_skills_ids())
	for i in possibleSkills:
		if i not in skills:
			skills.append(i)
	return skills



func cast_skill(id):
	var skillPath = "res://Resources/Skills/skill_003%d.tres"
	var idSkillPath = skillPath % id
	var skill:Skill = load(idSkillPath)
#	var target:UnitObject = get_ai_targets()
#	var target:UnitObject = get_ai_targets()
	#get equip
	var calcDamage = unitObject.get_unit_resource().strength + equipableObject.get_unit_resouce().strength
	calcDamage += skill.strength
	if skill.scriptToRun != null:
		var script = skill.scriptToRun.new()
		script.run()
		script.queue_free()
