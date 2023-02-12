extends Control


@onready var skillList = $PanelContainer/SkillList
@onready var skillListContainer = $PanelContainer/SkillList/VBoxContainer
@onready var skillButton = preload("res://SkillButton.tscn")

func _ready():
	skillListContainer.grab_focus()
#	Game.hide_ui.connect(free_ui)

func free_ui():
	queue_free()

func clear_ui():
	if !skillListContainer.get_children().is_empty():
		for i in skillListContainer.get_children():
			i.queue_free()

func populate_ui(unit:CharacterUnit):
	clear_ui()
	if !unit == null:
		print_debug(unit.get_unlocked_skills_ids())
		for i in unit.get_unlocked_skills_ids():
			var skill = Game.get_skill_by_id(i)
			if !skill == null:
				var sb = skillButton.instantiate()
				skillListContainer.add_child(sb)
				sb.set_skill(skill)
	else:
		print_debug("lack of unit")
		queue_free()


