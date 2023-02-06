extends Node
class_name AI
enum TYPE {SUPPORT,OFFENSE}
@export var currentType:TYPE = TYPE.OFFENSE
enum STATE {}
var stack:Array = []

## simple stack based FSM 

var currentState

	
func push_state(state):
	stack.append(state)
	if get_state() != state:
		stack.append(state)

func pop_state():
	stack.pop_front()

func get_state():

	return stack[-1]

func get_state_stack():
	return stack


#states here


#func _process(_delta):
#	var currentState = get_state()
#	if currentState != null and get_parent() != null:
#		get_parent().call(currentState)
#	else:
#		return 1  
