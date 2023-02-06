extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$"../../Cursor" == null:
		$Label.text = str($"../../Cursor".get_tile_cord()) + " , " + str($"../../Cursor".get_tile_type()) + "TURN: " + str($"../../TurnSystem".get_turn())


