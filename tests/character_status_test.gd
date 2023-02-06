extends Node

var unitToTest:Unit
# Called when the node enters the scene tree for the first time.
func _ready():
	unitToTest = load("res://Resources/test_unit.tres")
	print_debug(run_test())

# A functioning unit at its most complex has both personal and generic skills.

func run_test():
	if !unitToTest.personalSkills.is_empty():
		for i in unitToTest.personalSkills:
			if i == null:
				return "this is not a valid unit. There is a empty skill at: " + str(unitToTest.personalSkills.find(i))
			print_debug(i)
	if !unitToTest.attackSkills.is_empty():
		for i in unitToTest.attackSkills:
			if i == null:
				return "error"
			if unitToTest.attack >= i:
				print_debug("unit has a attack value of " + str(unitToTest.attack) + " unlocked skill id: " + str(unitToTest.attackSkills[i]))
		for i in unitToTest.speedSkills:
			if i == null:
				return "error"
			if unitToTest.speed >= i:
				print_debug("unit has a speed value of " + str(unitToTest.speed) + " unlocked skill id: " + str(unitToTest.speedSkills[i]))
		for i in unitToTest.focusSkills:
			if i == null:
				return "error"
			if unitToTest.focus >= i:
				print_debug("unit has a focus value of " + str(unitToTest.focus) + " unlocked skill id: " + str(unitToTest.focusSkills[i]))
	print_debug("unit has a starting spec of " + str(unitToTest.startingSpec))
	return "valid unit"
