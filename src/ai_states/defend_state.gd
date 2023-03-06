extends AI_STATE

class_name DefendState

func _run(unit:CharacterUnit):
	unit.unitObject.currentDefense = unit.unitObject.get_defense() + 5
