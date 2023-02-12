extends Area2D
class_name CharacterUnit
@onready var animationPlayer:AnimationPlayer = $AnimationPlayer
@onready var sprite3d:Sprite2D = $Sprite
@onready var ai:AI = $AI
@onready var unitObject:UnitObject = $UnitObject
@onready var equipableObject:EquipableObject = $EquipableObject
var acted = false
var defeated = false
var defaultState
var skillIds = []

func _ready():
	print_debug(get_unlocked_skills_ids())
	print_debug(is_valid_weilder())
	body_entered.connect(on_hover)
	body_exited.connect(on_hover_exited)
	reset_stats()
	defaultState = attack_state
	ai.push_state(defaultState)
	skillIds = get_unlocked_skills_ids()


func run_ai():
	reset_stats()
	await ai.get_state().call()
	print_debug(ai.get_state())
	


func defend_state():
	unitObject.currentDefense = unitObject.get_defense() + 5
	if unitObject.currentStamina >= 50:
		ai.pop_state()
		match(ai.currentType):
			ai.TYPE.OFFENSE:
				ai.push_state(attack_state())
			ai.TYPE.SUPPORT:
				ai.push_state(support_state())

func reset_stats():
	unitObject.currentDefense = unitObject.get_defense()
	unitObject.currentSpeed = unitObject.get_speed()
	unitObject.currentFocus = unitObject.get_focus()
	unitObject.currentStrength = unitObject.get_strength()

func attack_state():
	#find tile its occupying and its surronding 
	var allies = []
	var targetData = get_closest_unit_and_position()
	if !targetData.is_empty():
		var target = targetData.keys()[0]
		var targetPos = targetData.values()[0]
		var bestSkill = get_best_skill()
		var targets = targetData.keys()
		Game.cast_skill_from_ai(bestSkill,self,targets)


func get_best_skill() -> Skill:
	var s:Skill = Game.get_skill_by_id(skillIds[0])
	for i in skillIds:
		var potentialSkill = Game.get_skill_by_id(i)
		if potentialSkill.chargeCost < s.chargeCost:
			s = potentialSkill
	print_debug("the chosen best skill is: ", s)
	return s




func get_traversible_units():
	var dict = {}
	var trav = get_traversible_tiles()
	var allUnits = Game.currentEnemiesNodes + Game.currentPlayerNodes
	if !trav.is_empty():
		for i in allUnits:
			var unitPos = Game.currentTilemap.local_to_map(i.position)
			if unitPos in trav:
				dict[i] = unitPos
	print_debug(dict)
	return dict


func get_closest_unit_and_position():
	var dict = get_traversible_units()
	var newDict = {}
	for i in get_traversible_units():
		var vec = Vector2(dict[i]) 
		var distance = vec.distance_to(position)
		newDict[i] = dict[i]
		if newDict[i] is float and distance < newDict[i]:
			newDict.clear()
			newDict[i] = dict[i]
	print_debug(newDict)
	return newDict



func get_allies():
	var arr = []
	if !get_parent() == null:
		arr.append_array(get_parent().get_children())
	print_debug(arr)
	return arr

func get_traversible_tiles():
	var tiles = []
	if !Game.currentTilemap == null:
		var currentTilePos = Game.currentTilemap.local_to_map(position)
		for i in range(unitObject.get_unit_resource().movement):
			tiles.append_array(Game.currentTilemap.get_surrounding_cells(Vector2i(currentTilePos.x + i,currentTilePos.y + i)))
	print_debug(tiles)
	return tiles



func support_state():
	
	pass

func on_hover(body:Node2D):
	if body is Cursor:
		Game.focusedCharacter = self
		if unitObject.get_unit_resource() in Game.activeUnitsResouces.keys():
			print_debug("acted status is ", acted)
	#	Game.focusedEquip = equipableObject
		Game.show_ui.emit()


func on_hover_exited(body:Node2D):
	Game.hide_ui.emit()
	Game.focusedCharacter = null
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
	skills.append_array(unitObject.get_unlocked_skills_ids())
	if is_valid_weilder():
		skills.append_array(equipableObject.get_unlocked_skills_ids())
	return skills


func cast_skill(id):
	var skillPath = "res://Resources/Skills/skill_003%d.tres"
	var idSkillPath = skillPath % id
	var skill:Skill = load(idSkillPath)
	var target:UnitObject = get_ai_targets()
	#get equip
	var calcDamage = unitObject.get_unit_resource().strength + equipableObject.get_unit_resouce().strength
	calcDamage += skill.strength

	if skill.scriptToRun != null:
		var script = skill.scriptToRun.new()
		script.run()
		script.queue_free()



#make its own node?
func get_ai_targets():
	pass


# also add the ai functions
