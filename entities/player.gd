extends movement

@onready var hitbox = $hitbox

var velocity = Vector2.ZERO
@export var max_run: int = 100
@export var run_accel: int = 800
@export var gravity: int = 1000
@export var max_fall: int = 120
@export var jump_force: int = -160
@export var jump_hold: float = 0.2
var local_hold: float = 0.0
@export var flap_pause: float = 0.2
@export var flap_counter: int = 1
var flaps_counted: int = 0
@export var flap_hold_time: float = 0.1
var local_flap_hold_time: float = 0.0
var jump_done: bool

func _process(delta):
	
	var direction = sign(Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"))
	var grounded = Game.check_walls_collision(self, Vector2.DOWN)
	var jumping = Input.is_action_pressed("jump")
	var flap = Input.is_action_pressed("flap")
	
	if grounded:
		flaps_counted = flap_counter
	
	if grounded && jumping:
		jump_done = false
		velocity.y = jump_force
		$jumphold.start()
		$jumpholdboostless.start()
	elif $jumphold.time_left >0:
		if jumping:
			velocity.y = jump_force
		else:
			$jumphold.timeout
			$jumpholdboostless.timeout
	if !jumping:
		$jumpholdboostless.timeout.emit()
	
	local_hold -= delta
	
	
	
	velocity.x = move_toward(velocity.x, max_run * direction, run_accel*delta)
	velocity.y = move_toward(velocity.y, max_fall, gravity*delta)
	
	if !grounded && flap && flaps_counted > 0:
		jump_done = true
		$"flap delay".start()
		flaps_counted -= 1
	
	if $"flap delay".time_left > 0:
		velocity.y = 30
	
	if $"post-flap-hold".time_left > 0:
		if flap:
			velocity.y = -120
		else:
			$"post-flap-hold".timeout
	
	move_x(velocity.x * delta, Callable(func on_collision_x():
		velocity.x = 0
		zero_remainder_x()))
	move_y(velocity.y * delta, Callable(func on_collision_y():
		velocity.y = 0
		zero_remainder_y()))
	


func _on_timer_timeout():
	$"post-flap-hold".start()
	velocity.y += -120


func _on_jumpholdboostless_timeout():
	if flaps_counted == flap_counter && !jump_done:
		velocity.y = max_fall*0.5
		jump_done = true
