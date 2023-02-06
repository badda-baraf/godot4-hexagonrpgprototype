extends AnimatableBody2D

@onready var animationPlayer:AnimationPlayer = $AnimationPlayer
@onready var sprite3d:Sprite2D = $Sprite
@onready var ai:AI = $AI
@onready var unitObject:UnitObject = $UnitObject
@onready var equipableObject:EquipableObject = $EquipableObject


var defaultState

func _ready():
	print_debug(get_unlocked_skills_ids())
	print_debug(is_valid_weilder())
	mouse_entered.connect(on_hover)
	mouse_exited.connect(on_hover_exited)
	reset_stats()
	defaultState = attack_state
	ai.push_state(defaultState)


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
	
	pass

func support_state():
	
	pass

func on_hover():
	print_debug(unitObject.unitResource)
	print_debug(equipableObject.unitResource)
	Game.focusedUnit = unitObject
	Game.focusedEquip = equipableObject
	Game.show_ui.emit()


func on_hover_exited():
	print_debug("exited data")
	Game.hide_ui.emit()


func on_clicked():
	print_debug(unitObject.unitResource)
	print_debug(equipableObject.unitResource)
	pass

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
	var target:UnitObject = get_target()
	#get equip
	var calcDamage = unitObject.get_unit_resource().strength + equipableObject.get_unit_resouce().strength
	calcDamage += skill.strength

	if skill.scriptToRun != null:
		var script = skill.scriptToRun.new()
		script.run()
		script.queue_free()



#make its own node?
func get_target():
	pass


# also add the ai functions
