extends Button

class_name SkillButton

@export var skill:Skill

func _ready():
	grab_focus()

func set_skill(value:Skill):
	skill = value
	set_tooltip_text(skill.skillDescription)
	text = str(skill.name," Strength: ",skill.strength," Cost: ",skill.chargeCost," Type: ",skill.type)

func _pressed():
	if !skill == null:
#		Game.selectedSkill = skill
		await Game.cast_skill(skill,Game.selectedUnit)
#		Game.chosenSkill.emit()
	else:
		print_debug("the button holds no skill")

