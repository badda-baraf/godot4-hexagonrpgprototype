extends Node


var allUnitsPaths = {"res://Resources/Units/test_unit.tres":"","res://Resources/Units/test_unit2.tres":"","res://Resources/Units/test_unit3.tres":""}
signal show_ui
var activeUnits = {}
var focusedUnit
var focusedEquip
signal finishedAction
signal hide_ui
# Called when the node enters the scene tree for the first time.
func _ready():
	if activeUnits.is_empty():
		activeUnits = allUnitsPaths
		

