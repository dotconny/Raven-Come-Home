extends Node2D

@onready var player = $"../Player"
@export var camera_accel: int = 200
@export var max_camera_vel: int = 400
var velocity = Vector2.ZERO
var hold_counter: int = 0
var direction

func _ready():
	player.directionn.connect(directionset)

func directionset(num):
	direction = num
	print(direction)

func _process(delta):
	
	if direction != 0 && hold_counter < 2500:
		hold_counter += 500*delta
	else:
		hold_counter = 0
	global_position.x = player.global_position.x #- direction*hold_counter
	#var remainder = Vector2.ZERO
#	var direction = sign(player.global_position.x-global_position.x)
#	print(direction)
#	velocity.x = move_toward(velocity.x, direction*max_camera_vel, delta*camera_accel)
#	if direction == 0:
#		velocity.x = 0
#	remainder.x += velocity.x
#	var move = round(remainder.x)
#	if move != 0:
#		remainder.x -= move
#		var step = sign(move)
#		while move != 0:
#			global_position.x += step
#			move -= step
