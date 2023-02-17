extends Control


func _ready():
	Game.show_ui.connect(set_text)
	Game.hide_ui.connect(hide_ui)
func set_text():
	var focusedUnit = Game.focusedCharacter
	show()
	$PanelContainer/VBoxContainer/NameLabel.text = str(focusedUnit.unitObject.unitResource.unitName + " " + str(focusedUnit.acted))
	$PanelContainer/VBoxContainer/StaminaLabel.text = str(focusedUnit.unitObject.currentStamina) + "/" + str(focusedUnit.unitObject.maxStamina)
	$PanelContainer/VBoxContainer/AttackLabel.text =  "Strength: " + str(focusedUnit.unitObject.unitResource.strength)
	$PanelContainer/VBoxContainer/DefenseLabel.text = "Defense: " + str(focusedUnit.unitObject.unitResource.defense)
	$PanelContainer/VBoxContainer/FocusLabel.text = "Focus: " + str(focusedUnit.unitObject.unitResource.focus)
	$PanelContainer/VBoxContainer/SkillsLabel.text = "Skills: " + str(focusedUnit.skillIds)

func hide_ui():
	hide()
