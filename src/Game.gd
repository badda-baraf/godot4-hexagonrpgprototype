extends Node


var allUnitsPaths = {"res://Resources/Units/players_prototype/player_unit_mc.tres":"res://Resources/Equips/midandmid_equip.tres",
"res://Resources/Units/players_prototype/player_unit_rally.tres":"res://Resources/Equips/beefybutweak_equip.tres"
,"res://Resources/Units/players_prototype/player_unit_ranger.tres":"res://Resources/Equips/midandmid_equip.tres",
"res://Resources/Units/players_prototype/player_unit_skilled.tres":"res://Resources/Equips/midandmid_equip.tres",
"res://Resources/Units/players_prototype/player_unit_fighter.tres":"res://Resources/Equips/strongbutshort_equip.tres"}
signal show_ui
var activeUnits = {}
var activeUnitsResouces = {}
enum STATE {EXPLORE,BATTLE,CHOOSING}
var focusedUnit
var focusedCharacter:CharacterUnit
var focusedEquip
var selectedUnit
var selectedSkill
var actingCharacter
var actUi
var canvasLayer
var state = STATE.BATTLE
signal finishedAction
signal chosenSkill
signal hide_ui
signal selectedCharacter
var registaredSkills = []
var skillsPath = "res://Resources/Skills/"
var skillResourceTemplate = "skill_%03d.tres"
var currentCursor:Cursor
var currentTilemap:TileMap
var currentHighlightmap:TileMap
var currentEnemiesNodes = []
var currentPlayerNodes = []
var astarGird:AStarGrid2D
# Called when the node enters the scene tree for the first time.
func _ready():
	if activeUnits.is_empty():
		activeUnits = allUnitsPaths
	activeUnitsResouces = get_active_unit_resources()
	

func get_active_unit_resources():
	var dict = {}
	var oldDict = activeUnits
	for i in activeUnits:
		var unit = load(i)
		var equip = load(oldDict[i])
		dict[unit] = equip
#		dict.append(load(i))
		
	return dict

func cast_skill(skill:Skill,actor:CharacterUnit):
#	actingCharacter = selectedUnit
	actingCharacter = actor
	match(skill.costType):
		Skill.COSTTYPE.UNIT:
			actingCharacter.unitObject.currentStamina -= skill.chargeCost
		Skill.COSTTYPE.EQUIP:
			actingCharacter.equipableObject.currentStamina -= skill.chargeCost
	actingCharacter.acted = true
	print_debug("Casting skill")
	var targets = await get_targets(skill.maxTargets,skill.range)
	match(skill.effect):
		Skill.EFFECT.OFFENSIVE:
			for i in targets:
				print_debug(i,"is being casted on")
				print_debug(i.unitObject.get_current_defense())
				var trueEffect = (actingCharacter.unitObject.get_current_strength() + skill.strength) - i.unitObject.currentDefense
				for x in skill.statTargets:
					match x:
						Skill.STATTARGET.STAMINA:
							print_debug("attacking stamina")
#							i.unitObject.currentStamina -= trueEffect
							i.unitObject.currentStamina -= 50
						Skill.STATTARGET.STRENGTH:
							i.unitObject.strength -= trueEffect
				i.unitObject.check_health()
		Skill.EFFECT.SUPPORT:
			for i in targets:
				var trueEffect = skill.strength - i.unitObject.currentDefense
				for x in skill.statTargets:
					match x:
						Skill.STATTARGET.STAMINA:
							i.unitObject.currentStamina += trueEffect
						Skill.STATTARGET.STRENGTH:
							i.unitObject.strength += trueEffect
	if skill.scriptToRun:
		var script:Script = skill.scriptToRun.new()
		await script.run()
		script.queue_free()
	state = STATE.BATTLE
	chosenSkill.emit()
	


func cast_skill_from_ai(skill:Skill,caster:CharacterUnit,targets:Array):
	print_debug("targets are ", targets)
	match skill.costType:
		Skill.COSTTYPE.UNIT:
			caster.unitObject.currentStamina -= skill.chargeCost
		Skill.COSTTYPE.EQUIP:
			caster.equipableObject.currentStamina -= skill.chargeCost
	for i in targets:
		match skill.effect:
			Skill.EFFECT.OFFENSIVE:
				var trueEffect = (skill.strength + caster.unitObject.get_current_strength()) - i.unitObject.get_current_defense()
				for x in skill.statTargets:
					match x:
						Skill.STATTARGET.STAMINA:
							var oldStamina = i.unitObject.currentStamina
							i.unitObject.currentStamina -= trueEffect
							i.unitObject.check_health()
							print_debug(oldStamina," old stamina now stamina is ",i.unitObject.currentStamina )
						Skill.STATTARGET.STRENGTH:
							i.unitObject.currentStrength -= trueEffect

			Skill.EFFECT.SUPPORT:
				var trueEffect = (skill.strength + caster.unitObject.get_current_strength()) + i.unitObject.get_current_defense()
				for x in skill.statTargets:
					match x:
						Skill.STATTARGET.STAMINA:
							var oldStamina = i.unitObject.currentStamina
							i.unitObject.currentStamina += trueEffect
							i.unitObject.check_health()
							print_debug(oldStamina," old stamina now stamina is ",i.unitObject.currentStamina )
						Skill.STATTARGET.STRENGTH:
							i.unitObject.currentStrength += trueEffect
	if skill.scriptToRun:
		var script:Script = skill.scriptToRun.new()
		await script.run()
		script.queue_free()



func get_targets(targetMax:int,range:int) -> Array[CharacterUnit]:
#	hide_ui.emit()
	var arr:Array[CharacterUnit] = []
	var castMenu = load("res://CastMenu.tscn").instantiate()
	canvasLayer.add_child(castMenu)
	var index = arr.size()
	while(!arr.size() == targetMax):
#	for i in range(targetMax):
		castMenu.label.text = "targets left: " + str(arr.size() + 1)
		actUi.hide()
		await selectedCharacter
		print_debug(selectedUnit)
		print_debug(actingCharacter)
		if selectedUnit == actingCharacter:
			print_debug("cant cast on yourself")
		elif selectedUnit is CharacterUnit:
			arr.append(selectedUnit)
			selectedUnit = null
	castMenu.queue_free()
	return arr


func get_skill_by_id(id:int):
	var skill:Skill
	var completeSkillPath = str(skillsPath,skillResourceTemplate % id)
#	print_debug(completeSkillPath)
	if FileAccess.file_exists(completeSkillPath):
		skill = load(completeSkillPath)
		return skill
	else:
		return null
	
