extends Resource


class_name Unit
# this is beta rn since i want it to scale well. 
# probably have a check if the id is taken then print error and assign a new number id
@export var unitName = ""
@export var id:int = 0
@export var stamina:int = 15
@export var strength:int = 5
@export var defense:int = 5
@export var speed:int = 5
@export var focus:int = 5
@export var startingSpec:int = 10
@export var personalSkills:Array[Skill] = []
#Im not sure if having an object be directly connected to the dict is a good idea so 
# ill try a int (level) key as well as a int value that serves as the "pointer" to the skill object


@export var strengthSkills:Dictionary = {1:30,30:80}
@export var speedSkills:Dictionary = {40:90,30:80}
@export var focusSkills:Dictionary = {80:30,40:80}
@export var defenseSkills:Dictionary = {80:30,40:80}
@export var movement:int = 5
var genericSkills:Array[Dictionary] = [strengthSkills,speedSkills,focusSkills,defenseSkills]
