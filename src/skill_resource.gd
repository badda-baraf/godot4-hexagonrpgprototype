extends Resource
class_name Skill
# black -> White
# White -> Grey
# Grey -> Black
enum TYPE {BLACK,WHITE,GREY}
@export var id = 0
@export var chargeCost = 2
@export var name = "skill name"
@export var type:TYPE = TYPE.GREY
@export var strength = 10
@export var scriptToRun:Script

