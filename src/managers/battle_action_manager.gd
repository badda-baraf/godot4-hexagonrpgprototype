extends Node


func run():
	pass

func get_targets(attacker:CharacterUnit,targetMax:int,range:int) -> Array[CharacterUnit]:
#	hide_ui.emit()
	print_debug(range)
	var tilesInRange:Array = attacker.get_traversible_tiles(attacker.position)
	var currentTilePos:Vector2i = Game.currentTilemap.local_to_map(attacker.position)
	for i in range(range - 1):
			tilesInRange.append_array(Game.currentTilemap.get_surrounding_cells(Vector2i(currentTilePos.x + i,currentTilePos.y)))
			tilesInRange.append_array(Game.currentTilemap.get_surrounding_cells(Vector2i(currentTilePos.x - i,currentTilePos.y)))
			tilesInRange.append_array(Game.currentTilemap.get_surrounding_cells(Vector2i(currentTilePos.x,currentTilePos.y - i)))
			tilesInRange.append_array(Game.currentTilemap.get_surrounding_cells(Vector2i(currentTilePos.x,currentTilePos.y + i)))
	print_debug("the tiles youre allowed are these:", tilesInRange)
	var arr:Array[CharacterUnit] = []
	var castMenu = load("res://CastMenu.tscn").instantiate()
	Game.canvasLayer.add_child(castMenu)
	var index = arr.size()
	highlight_tile_array(tilesInRange)
	Game.state = Game.STATE.CHOOSING
	while(!arr.size() == targetMax):
#	for i in range(targetMax):
		castMenu.label.text = "targets left: " + str(arr.size() + 1)
		Game.actUi.hide()
		await Game.selectedCharacter
		print_debug(Game.selectedUnit)
		print_debug(Game.actingCharacter)
		if Game.selectedUnit == Game.actingCharacter:
			print_debug("cant cast on yourself")
		elif Game.selectedUnit is CharacterUnit:
			var selectedCharactersTile:Vector2i = Game.currentTilemap.local_to_map(Game.selectedUnit.position)
			if selectedCharactersTile in tilesInRange:
				arr.append(Game.selectedUnit)
				Game.selectedUnit = null
			else:
				print_debug("Unit isnt in range")
				Game.selectedUnit = null
	castMenu.queue_free()
	dehighlight()
	Game.state = Game.STATE.BATTLE
	return arr



func highlight_tile_array(arr):
	for i in arr:
		Game.currentHighlightmap.set_cell(0,i,0,Vector2i(0,2),2)

func dehighlight():
	if Game.state == Game.STATE.CHOOSING:
		Game.currentHighlightmap.clear_layer(0)

func cast_skill(skill:Skill,actor:CharacterUnit):
#	actingCharacter = selectedUnit
	Game.currentCursor.set_process_input(true)
	Game.actingCharacter = actor
	match(skill.costType):
		Skill.COSTTYPE.UNIT:
			Game.actingCharacter.unitObject.currentStamina -= skill.chargeCost
		Skill.COSTTYPE.EQUIP:
			Game.actingCharacter.equipableObject.currentStamina -= skill.chargeCost
	Game.actingCharacter.acted = true
	print_debug("Casting skill")
	var targets = await get_targets(actor,skill.maxTargets,skill.range)
	match(skill.effect):
		Skill.EFFECT.OFFENSIVE:
			for i in targets:
				print_debug(i,"is being casted on")
				print_debug(i.unitObject.get_current_defense())
				var trueEffect = (Game.actingCharacter.unitObject.get_current_strength() + skill.strength) - i.unitObject.currentDefense
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
	Game.state = Game.STATE.BATTLE
	Game.focusedCharacter = null
	Game.chosenSkill.emit()




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






