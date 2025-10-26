extends movement
class_name player

@onready var hitbox = $hitbox
@onready var hitbox2 = $hitbox2
@onready var hitbox3 = $hitbox3

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
@export var pokeability: bool
var poking: bool = false
var poke_buffer: bool = true
@export var new_poke_timer: float = 0.2
var local_poke_timer: float = 0.0
var lpoke: bool
var rpoke: bool
@export var freeze: int = 900
@export var poke_counter: int = 1
var local_poke_counter: int
var temppoker = lpoke
var temppokel = rpoke
var pokejumpbuffer: bool = false
signal directionn(num)

func _process(delta):
	
	var direction = sign(Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"))
	directionn.emit(direction) 
	var grounded = Game.check_walls_collision(self, Vector2.DOWN)
	var jumping = Input.is_action_pressed("jump")
	var flap = Input.is_action_pressed("flap")
	
	if grounded:
		flaps_counted = flap_counter
		velocity.y = 0
		local_poke_counter = poke_counter
		$pokebuffer.timeout.emit()
	
	if grounded && jumping:
		jump()
	elif $jumphold.time_left >0:
		if jumping:
			velocity.y = jump_force*2
		else:
			$jumphold.timeout.emit()
			$jumpholdboostless.timeout.emit()
	if !jumping:
		$jumpholdboostless.timeout.emit()
	
	local_hold -= delta
	
	
	velocity.x = move_toward(velocity.x, max_run * direction, run_accel*delta)
	if !grounded:
		velocity.y = move_toward(velocity.y, max_fall, gravity*delta)
	
	if !grounded && flap && flaps_counted > 0:
		flap()
	
	if $"flap delay".time_left > 0:
		if poke_buffer:
			velocity.y = 30
		else:
			velocity.y = 0
			velocity.x = 0
	
	if $"post-flap-hold".time_left > 0:
		if flap:
			velocity.y = -120
		else:
			$"post-flap-hold".timeout
	
	if Game.check_left_poke_collision(self, Vector2(sign(velocity.x*delta),0)) || Game.check_right_poke_collision(self, Vector2(sign(velocity.x*delta),0)):
		if Input.is_action_pressed("poke") && !poking && poke_buffer && local_poke_counter > 0:
			$poketimer.start()
			flaps_counted = flap_counter
			poking = true
			local_poke_counter -= 1
			if Game.check_left_poke_collision(self, Vector2(sign(velocity.x*delta),0)):
				lpoke = true
			elif  Game.check_right_poke_collision(self, Vector2(sign(velocity.x*delta),0)):
				rpoke = true
	
	if poking:
		if jumping && $poketimer.time_left > 0:
			temppoker = lpoke
			temppokel = rpoke
			pokejumpbuffer = true
			$pokejumpbuffer.start()
			poking = false
			rpoke = false
			lpoke = false
			$poketimer.timeout.emit()
		elif flap:
			#poke_flap()
			poking = false
			rpoke = false
			lpoke = false
			$poketimer.timeout.emit()
			#$"flap delay".timeout.emit()
		if $poketimer.time_left > 0:
			velocity.y = 0
			velocity.x = move_toward(velocity.x, 0, freeze*delta)
	
	if pokejumpbuffer:
		velocity.y = 0
	
	if !poking:
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
		
		jump_done = true
		if velocity.y < 0:
			velocity.y = 0


func _on_poketimer_timeout():
	poking = false
	rpoke = false
	lpoke = false
	poke_buffer = false
	$pokebuffer.start()

func jump():
	jump_done = false
	velocity.y = jump_force*4
	$jumphold.start()
	$jumpholdboostless.start()

func _on_pokebuffer_timeout():
	poke_buffer = true

func flap():
	jump_done = true
	$"flap delay".start()
	flaps_counted -= 1

func poke_flap():
	local_poke_timer += new_poke_timer


func _on_pokejumpbuffer_timeout() -> void:
	if temppokel:
		velocity.x = 300
		velocity.y = -160
	if temppoker:
		velocity.x = -300
		velocity.y = -160
	temppokel = false
	temppoker = false
	pokejumpbuffer = false
