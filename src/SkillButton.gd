extends TextureButton

class_name SkillButton

@export var skill:Skill
@onready var text = $RichTextLabel
func _ready():
	grab_focus()

func set_skill(value:Skill):
	skill = value
	set_tooltip_text(skill.skillDescription)
	text.text = str(skill.name," Strength: ",skill.strength," Cost: ",skill.chargeCost," Type: ",skill.type)


#func _gui_input(event):
#	if has_focus() and event.is_action_pressed("act"):
#		accept_event()
#		_pressed()
#	if event.is_action_pressed("ui_down"):
#		get_node(focus_next).grab_focus()
func _pressed():
	if !skill == null:
#		Game.selectedSkill = skill
		Game.actUi.hide()
		await BattleActionManager.cast_skill(skill,Game.selectedUnit)
#		Game.chosenSkill.emit()
	else:
		print_debug("the button holds no skill")

