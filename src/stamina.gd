extends Node


class_name Stamina

var currentStamina
func _ready():
	pass

func get_health():
	return currentStamina

func set_health(value):
	currentStamina = value


func check_health():
	if get_health() <= 0:
		print_debug("")

