extends Node3D


class_name Entity


var ai:AI

func _ready():
	ai.push_state("lookout")

func standby():
	pass

func lookout():
	# if low hp
	ai.pop_state()
	ai.push_state("runaway")
	#if in range
	ai.pop_state()
	ai.push_state("attack")

func attack():
	pass

func support():
	pass

func runaway():
	pass
