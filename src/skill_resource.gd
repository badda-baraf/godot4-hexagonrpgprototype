extends Resource
class_name Skill
# black -> White
# White -> Grey
# Grey -> Black
enum TYPE {BLACK,WHITE,GREY}
enum COSTTYPE {UNIT,EQUIP}
enum EFFECT{SUPPORT,OFFENSIVE}
enum STATTARGET{STAMINA,STRENGTH,DEFENSE,SPEED,FOCUS}
@export var name = "skill name"
@export var type:TYPE = TYPE.GREY
@export var effect:EFFECT = EFFECT.OFFENSIVE
@export var statTargets:Array[STATTARGET] = [STATTARGET.STAMINA]
@export var costType:COSTTYPE = COSTTYPE.UNIT
@export var strength = 10
@export var chargeCost = 2
@export var range = 1
@export var maxTargets = 1
@export var scriptToRun:Script
@export var skillDescription = "Default Description"
