extends Button


func _ready():
	var id = get_index()
	text = str(id)

func set_icon(id):
	var path = "res://Resources/Icons/icon_%3d.png"
	var tex_icon = path % id
