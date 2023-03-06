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






func get_skill_by_id(id:int):
	var skill:Skill
	var completeSkillPath = str(skillsPath,skillResourceTemplate % id)
#	print_debug(completeSkillPath)
	if FileAccess.file_exists(completeSkillPath):
		skill = load(completeSkillPath)
		return skill
	else:
		return null
	
