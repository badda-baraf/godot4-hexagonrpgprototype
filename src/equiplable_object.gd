extends UnitObject

class_name EquipableObject

@export var equipableResource:Equipable
var weilder:UnitObject = self

func _ready():
	if equipableResource == null:
		equipableResource = load("res://Resources/test_equip.tres")

func get_unit_resource():
	return equipableResource


func set_weilder(value):
	weilder = value

func get_weilder():
	return weilder

func get_weilder_id() -> int:
	if get_parent() == null:
		return -1
	else:
		return 0

func get_equiplable_ids():
	return equipableResource.equipableIds
