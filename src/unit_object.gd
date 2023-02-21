extends Node
class_name UnitObject

@export var unitResource:Unit
@export var defeatedColor:Color
signal entered
signal exited
var addedSpecPoints = 0
var currentStrength
var currentFocus
var currentSpeed
var currentDefense
var currentStamina
var maxStamina
var skills
var defeated = false
func _ready():
	if unitResource == null:
		unitResource = load("res://Resources/test_unit.tres")
	set_current_stats_to_resource()


func level_up():
	pass

func set_current_stats_to_resource():
	maxStamina = get_stamina()
	currentStamina = maxStamina
	currentStrength = get_strength()
	currentDefense = get_defense()
	currentSpeed = get_speed()
	currentFocus = get_focus()

func get_unit_resource():
	return unitResource

func check_health():
	print_debug(unitResource.unitName , ": " , str(get_current_stamina()))
	if get_current_stamina() <= 0:
		get_parent().modulate = defeatedColor
		defeated = true
#		get_parent().queue_free()

func get_unlocked_skills_ids():
	var unit = get_unit_resource()
	var strengthSkills = unit.strengthSkills
	var speedSkills = unit.speedSkills
	var focusSkills = unit.focusSkills
	var defenseSkills = unit.defenseSkills
	var skills = []
	if !strengthSkills.is_empty():
		for i in strengthSkills:
			if unit.strength >= i:
				if i not in skills:
					skills.append(strengthSkills[i])
	if !speedSkills.is_empty():
		for i in speedSkills:
			if unit.speed >= i:
				if i not in skills:
					skills.append(speedSkills[i])
	if !focusSkills.is_empty():
		for i in focusSkills:
			if unit.focus >= i:
				if i not in skills:
					skills.append(focusSkills[i])
	if !defenseSkills.is_empty():
		for i in defenseSkills:
			if unit.defense >= i:
				if i not in skills:
					skills.append(defenseSkills[i])
	skills.append_array(unit.personalSkills)
	
	return skills


func get_current_stamina():
	return currentStamina

func get_current_strength():
	return currentStrength

func get_current_defense():
	return currentDefense

func get_current_speed():
	return currentSpeed

func get_current_focus():
	return currentFocus

func get_stamina():
	return get_unit_resource().stamina
func get_defense():
	return get_unit_resource().defense

func get_strength():
	return get_unit_resource().strength

func get_focus():
	return get_unit_resource().focus

func get_speed():
	return get_unit_resource().speed

func get_unit_strength_skills():
	return get_unit_resource().strengthSkills

func get_unit_focus_skills():
	return get_unit_resource().focusSkills

func get_unit_speed_skills():
	return get_unit_resource().speedSkills

func get_unit_defense_skills():
	return get_unit_resource().defenseSkills
