extends Node2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var tilemap = $"../TileMapLayer"

var horizontal = false
var moving = false
var movable = false
var mouse_in_ship = false

func _physics_process(delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	mouse_position -= Global.TILE_SIZE/2
	
	if overlap_count > 0:
		colliding = true
	else:
		colliding = false
	if movable:
		if Input.is_action_just_pressed("click"):
			move_to_front()
			Global.is_dragging = true
			moving = true
			movable = false
	elif moving and not colliding:
		if Input.is_action_just_pressed("click"):
			Global.is_dragging = false
			moving = false
			if not mouse_in_ship:
				var currentAnim = sprite.animation
				var currentFrame = sprite.frame
				sprite.play("default")
				sprite.frame = currentFrame
			
	
	if Input.is_action_just_pressed("rotate") and moving == true:
		if horizontal == false:
			horizontal = true
			rotation_degrees += 90
		else:
			horizontal = false
			rotation_degrees -= 90
		
	if horizontal == false and moving == true:
		# bottom left corner
		if tilemap.local_to_map(mouse_position).x < 6 and tilemap.local_to_map(mouse_position).y > 10:
			mouse_position = tilemap.map_to_local(Vector2(4, 10))
		# bottom right corner
		elif tilemap.local_to_map(mouse_position).x > 11 and tilemap.local_to_map(mouse_position).y > 10:
			mouse_position = tilemap.map_to_local(Vector2(11, 10))
		# top left corner
		elif tilemap.local_to_map(mouse_position).x < 6 and tilemap.local_to_map(mouse_position).y < 7:
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
	elif horizontal == true and moving == true:
		# bottom left corner
		if tilemap.local_to_map(mouse_position).x < 7 and tilemap.local_to_map(mouse_position).y > 10:
			mouse_position = tilemap.map_to_local(Vector2(5, 11))
		# bottom right corner
		elif tilemap.local_to_map(mouse_position).x > 10 and tilemap.local_to_map(mouse_position).y > 10:
			mouse_position = tilemap.map_to_local(Vector2(10, 11))
		# top left corner
		elif tilemap.local_to_map(mouse_position).x < 7 and tilemap.local_to_map(mouse_position).y < 6:
			mouse_position = tilemap.map_to_local(Vector2(5, 4))
		# top right corner
		elif tilemap.local_to_map(mouse_position).x > 10 and tilemap.local_to_map(mouse_position).y < 6:
			mouse_position = tilemap.map_to_local(Vector2(10, 4))
		# left edge
		elif tilemap.local_to_map(mouse_position).x < 6 and tilemap.local_to_map(mouse_position).y > 5 and tilemap.local_to_map(mouse_position).y < 11:
			mouse_position.x = tilemap.map_to_local(Vector2(5, 0)).x
		# right edge
		elif tilemap.local_to_map(mouse_position).x > 10 and tilemap.local_to_map(mouse_position).y > 5 and tilemap.local_to_map(mouse_position).y < 11:
			mouse_position.x = tilemap.map_to_local(Vector2(10, 0)).x
		# bottom edge
		elif tilemap.local_to_map(mouse_position).y > 11 and tilemap.local_to_map(mouse_position).x > 5 and tilemap.local_to_map(mouse_position).x < 12:
			mouse_position.y = tilemap.map_to_local(Vector2(0, 11)).y
		# top edge
		elif tilemap.local_to_map(mouse_position).y < 6 and tilemap.local_to_map(mouse_position).x > 5 and tilemap.local_to_map(mouse_position).x < 12:
			mouse_position.y = tilemap.map_to_local(Vector2(0, 4)).y
		
	if moving == true:
		global_position = mouse_position.snapped(Global.TILE_SIZE) + Global.TILE_SIZE/2.0 + Global.OFFSET
	

func switch_floating_animation() -> void:
	var currentAnim = sprite.animation
	var currentFrame = sprite.frame
	if currentAnim == "default":
		sprite.play("hovering")
	elif currentAnim == "hovering":
		sprite.play("default")
	sprite.frame = currentFrame + 0.1
	
func switch_collision_animation() -> void:
	var currentAnim = sprite.animation
	var currentFrame = sprite.frame
	if currentAnim == "default":
		sprite.play("collision")
	elif currentAnim == "hovering":
		sprite.play("collision")
	elif currentAnim == "collision":
		sprite.play("default")
	sprite.frame = currentFrame


func _on_area_2d_mouse_entered() -> void:
	mouse_in_ship = true
	if not moving and not Global.is_dragging:
		switch_floating_animation()
		movable = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in_ship = false
	if not moving and not Global.is_dragging:
		switch_floating_animation()
		movable = false


var overlap_count = 0
var colliding = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if moving:
		overlap_count += 1
		print(overlap_count)
		var currentAnim = sprite.animation
		var currentFrame = sprite.frame
		sprite.play("collision")
		sprite.frame = currentFrame


func _on_area_2d_area_exited(area: Area2D) -> void:
	if moving:
		overlap_count -= 1
		print(overlap_count)
		if overlap_count <= 0:
			var currentAnim = sprite.animation
			var currentFrame = sprite.frame
			sprite.play("hovering")
			sprite.frame = currentFrame
