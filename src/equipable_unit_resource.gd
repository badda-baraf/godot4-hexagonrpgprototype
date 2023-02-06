extends Unit

class_name Equipable

@export var equipableIds:Array[int] = []
@export var benifitIds:Array[int] = []



#is it isnt empty it means its a exclusive weapon it checks the id of the unit weilding it. 
# if not match then wont allow to equip 
func check_valid():
	if !equipableIds.is_empty():
		pass
