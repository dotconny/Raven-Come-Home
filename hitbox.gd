@tool
extends Node2D

@export var x: int = 0
@export var y: int = 0
@export var width: int = 16
@export var height: int = 16
@export var color = Color(0,0,1,0.5)

var left: get = get_left
var right: get = get_right
var top: get = get_top
var bottom: get = get_bottom

func get_left():
	return global_position.x + x

func get_right():
	return global_position.x + x + width

func get_top():
	return global_position.y + y

func get_bottom():
	return global_position.y + y + height

func _draw():
	draw_rect(Rect2(x,y,width,height),color)

func _process(delta):
	pass

func intersects(other, offset: Vector2):
	return ((self.right + offset.x) > other.left && (self.left + offset.x) < other.right 
	&& (self.bottom + offset.y) > other.top && (self.top + offset.y) < other.bottom)
	
	
	
	
