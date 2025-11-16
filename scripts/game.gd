extends Node

func check_walls_collision(entity, offset):
	var walls = get_tree().get_nodes_in_group("wall")
	for wall in walls:
		if entity.hitbox.intersects(wall.hitbox, offset):
			return true
	return false

func check_left_poke_collision(entity, offset):
	var walls = get_tree().get_nodes_in_group("wall")
	for wall in walls:
		if entity.hitbox2.intersects(wall.hitbox, offset):
			return true
	return false

func check_right_poke_collision(entity, offset):
	var walls = get_tree().get_nodes_in_group("wall")
	for wall in walls:
		if entity.hitbox3.intersects(wall.hitbox, offset):
			return true
	return false


func check_camera_collision(entity, offset):
	var cameras = get_tree().get_nodes_in_group("cameras")
	for camera in cameras:
		if entity.hitbox.intersects(camera.hitbox, offset):
			return camera.name
	return false

func get_all_actors():
	return get_tree().get_nodes_in_group("Actors")

func get_all_riding_actors(solid):
	var riders: Array
	var actors = get_tree().get_nodes_in_group("Actors")
	for actor in actors:
		if actor.is_riding(solid, Vector2.DOWN):
			riders.append(actor)
	return riders
