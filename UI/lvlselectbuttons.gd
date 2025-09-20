extends HBoxContainer

func _ready():
	for button in get_tree().get_nodes_in_group("lvlselect"):
		button.pressed.connect(Callable(self, "buttonpressed").bind(button.name))

func buttonpressed(name):
	get_tree().change_scene_to_file("res://levels/lvl_" + name + ".tscn")
