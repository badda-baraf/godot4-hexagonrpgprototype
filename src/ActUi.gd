extends Control


@onready var skillList = $TextureRect/SkillList
@onready var skillListContainer = $TextureRect/SkillList/VBoxContainer
@onready var skillButton = preload("res://SkillButton.tscn")
var focusedButton


func _ready():
	Game.actUi = self
#	skillListContainer.grab_focus()
#	skillListContainer.grab_focus()
#	set_button_neighbors()
#	Game.hide_ui.connect(free_ui)




func free_ui():
	queue_free()

func clear_ui():
	if !skillListContainer.get_children().is_empty():
		for i in skillListContainer.get_children():
			i.queue_free()

func populate_ui(unit:CharacterUnit):
	clear_ui()
	Game.currentCursor.set_process_input(false)
	if !unit == null:
		print_debug(unit.get_unlocked_skills_ids())
		for i in unit.get_unlocked_skills_ids():
			var skill
			if i is int:
				skill = Game.get_skill_by_id(i)
			else:
				skill = i
			if !skill == null:
				var sb = skillButton.instantiate()
				skillListContainer.add_child(sb)
				sb.set_skill(skill)
#				sb.grab_focus()
		set_button_neighbors()
	else:
		print_debug("lack of unit")
		queue_free()


func set_button_neighbors():
	print_debug("setting controls")
	focusedButton = skillListContainer.get_child(0)
	focusedButton.grab_focus()
	

