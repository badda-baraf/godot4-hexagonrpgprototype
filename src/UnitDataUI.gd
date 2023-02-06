extends Control


func _ready():
	Game.show_ui.connect(set_text)
	Game.hide_ui.connect(hide_ui)
func set_text():
	show()
	$PanelContainer/VBoxContainer/NameLabel.text = str(Game.focusedUnit.unitResource.unitName)
	$PanelContainer/VBoxContainer/AttackLabel.text = str(Game.focusedUnit.unitResource.strength)
	$PanelContainer/VBoxContainer/DefenseLabel.text = str(Game.focusedUnit.unitResource.defense)
	$PanelContainer/VBoxContainer/FocusLabel.text = str(Game.focusedUnit.unitResource.focus)
	$PanelContainer/VBoxContainer/SkillsLabel.text = str(Game.focusedUnit.get_unlocked_skills_ids())

func hide_ui():
	hide()
