extends Node2D
@onready var hitbox = $hitbox

func _ready():
	add_to_group("wall")
	
