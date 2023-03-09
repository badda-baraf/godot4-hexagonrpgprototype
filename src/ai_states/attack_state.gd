extends AI_STATE

class_name AttackState

func _run(unit:CharacterUnit):
	print_debug("attack state")
	#find tile its occupying and its surronding 
	var allies = []
	if unit.get_traversible_units(unit.position).is_empty():
		print_debug("no units in range of this units movement proceeding to move until unit")
		if unit.agrrod:
			unit.move_until_unit()
		else:
			active = false
	else:
		var targetData = unit.get_closest_unit_and_position_from_given_position(unit.position)
		if !targetData.is_empty():
			var target = targetData.keys()[0]
			var targetPos = targetData.values()[0]
			var bestSkill = unit.get_best_skill()
			var targets = targetData.keys()
			BattleActionManager.cast_skill_from_ai(bestSkill,unit,targets)
