extends "res://wall.gd"

var remainder = Vector2.ZERO

func move_y(amount):
	remainder.y += amount
	var move = round(remainder.y)
	if(move!= 0):
		var riders = Game.get_all_riding_actors(self)
		remainder.y -= move
		global_position.y += move
		for actor in Game.get_all_actors():
			if hitbox.intersects(actor.hitbox, Vector2.ZERO):
				if move>0:
					actor.move_y_exact(hitbox.bottom - actor.hitbox.top, Callable(actor, "squish"))
				else:
					actor.move_y_exact(hitbox.top - actor.hitbox.bottom, Callable(actor, "squish"))
			elif riders.has(actor):
				actor.move_y_exact(move, null)
