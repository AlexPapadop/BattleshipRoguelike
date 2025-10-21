extends Node2D

@onready var tilemap = $"../TileMapLayer"

var horizontal = false


func _physics_process(delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	mouse_position -= Global.TILE_SIZE/2
	
	if Input.is_action_just_pressed("rotate"):
		if horizontal == false:
			horizontal = true
			rotation_degrees += 90
		else:
			horizontal = false
			rotation_degrees -= 90
	if horizontal == false:
		# bottom left corner
		if tilemap.local_to_map(mouse_position).x < 7 and tilemap.local_to_map(mouse_position).y > 10:
			mouse_position = tilemap.map_to_local(Vector2(4, 10))
		# bottom right corner
		elif tilemap.local_to_map(mouse_position).x > 11 and tilemap.local_to_map(mouse_position).y > 10:
			mouse_position = tilemap.map_to_local(Vector2(11, 10))
		# top left corner
		elif tilemap.local_to_map(mouse_position).x < 7 and tilemap.local_to_map(mouse_position).y < 7:
			mouse_position = tilemap.map_to_local(Vector2(4, 5))
		# top right corner
		elif tilemap.local_to_map(mouse_position).x > 11 and tilemap.local_to_map(mouse_position).y < 7:
			mouse_position = tilemap.map_to_local(Vector2(11, 5))
		# left edge
		elif tilemap.local_to_map(mouse_position).x < 5 and tilemap.local_to_map(mouse_position).y > 4 and tilemap.local_to_map(mouse_position).y < 11:
			mouse_position.x = tilemap.map_to_local(Vector2(4, 0)).x
		# right edge
		elif tilemap.local_to_map(mouse_position).x > 11 and tilemap.local_to_map(mouse_position).y > 4 and tilemap.local_to_map(mouse_position).y < 11:
			mouse_position.x = tilemap.map_to_local(Vector2(11, 0)).x
		# bottom edge
		elif tilemap.local_to_map(mouse_position).y > 10 and tilemap.local_to_map(mouse_position).x > 5 and tilemap.local_to_map(mouse_position).x < 12:
			mouse_position.y = tilemap.map_to_local(Vector2(0, 10)).y
		# top edge
		elif tilemap.local_to_map(mouse_position).y < 7 and tilemap.local_to_map(mouse_position).x > 5 and tilemap.local_to_map(mouse_position).x < 12:
			mouse_position.y = tilemap.map_to_local(Vector2(0, 5)).y
		
		
	global_position = mouse_position.snapped(Global.TILE_SIZE) + Global.TILE_SIZE/2.0 + Global.OFFSET
	
