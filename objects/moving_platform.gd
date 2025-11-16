extends "res://scripts/movingsolids.gd"

@onready var tween = get_tree().create_tween()
@onready var start = global_position
@onready var follow = global_position

@export var offset = Vector2.ZERO
@export var time: float = 2
@export var delay: float = 3


func _ready():
	init_tween()

func init_tween():
	#tween.set_loops()
	#tween.tween_property(self,"global_position",start+offset,time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_delay(delay)
	#tween.tween_property(self,"global_position",start,time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_delay(delay*2)
	#tween.connect("tween_step", Callable(self, "_on_tween_step"))
	tween.set_loops()
	tween.tween_method(Callable(self, "_on_tween_step"),0.0,1.0,time)
	tween.tween_property(self,"follow",start + offset,time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(delay)
	tween.tween_method(Callable(self, "_on_tween_step"),0.0,1.0,time)
	tween.tween_property(self,"follow",start,time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func on_tween_step(onject, key, elapsed, value):
	var remainder = follow - global_position
	move_y(follow.y - (global_position.y + remainder.y))
