extends CharacterBody3D

@export var speed: float = 5.0
@export var player: CharacterBody3D
@export var camera: Camera3D
@export var spot_light: SpotLight3D

var agent: NavigationAgent3D
var has_teleported := false
var teleport_pause := false
var teleport_delay := 2.5  # seconds to wait after teleport
var teleport_timer := 0.0
var visible_lights: Array[SpotLight3D] = []

func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array

func _ready():
	agent = $NavigationAgent3D
	agent.target_position = global_transform.origin  # Stay still initially
	#player = get_node("FPPlayer")
	#camera = get_node("Camera3D")
	
	for element in get_all_children(get_tree().get_root()):
		if element is SpotLight3D:
			visible_lights.append(element)


func is_under_any_spotlight() -> bool:
	for light in visible_lights:
		if is_under_spotlight(light):
			return true
	return false

func is_under_spotlight(light: SpotLight3D) -> bool:
	var light_pos = light.global_transform.origin
	var light_dir = -light.global_transform.basis.z.normalized()
	var to_enemy = global_transform.origin - light_pos
	var distance = to_enemy.length()

	if distance > light.spot_range:
		return false

	var angle_cos = light_dir.dot(to_enemy.normalized())
	var limit_cos = cos(deg_to_rad(light.spot_angle))
	if angle_cos < limit_cos:
		return false

	var space_state = get_world_3d().direct_space_state
	var ray = PhysicsRayQueryParameters3D.create(light_pos, global_transform.origin)
	ray.exclude = [self, light]
	var result = space_state.intersect_ray(ray)

	if result.is_empty() or result["collider"] == self:
		return true

	return false



func _physics_process(delta):
	if teleport_pause:
		teleport_timer -= delta
		if teleport_timer <= 0.0:
			teleport_pause = false
	else:
		if (is_seen_by_camera() and is_under_any_spotlight()):
			velocity = Vector3.ZERO
			move_and_slide()
			has_teleported = false
		else : 
			if not has_teleported:
				teleport_around_player()
				has_teleported = true
				teleport_pause = true
				teleport_timer = teleport_delay
			agent.target_position = player.global_transform.origin
			move_along_path(delta)
			


func caught():
	return agent.distance_to_target() < 1.1


func move_along_path(delta):
	if caught():
		print("gameOver")
		return
	var next_point = agent.get_next_path_position()
	var direction = (next_point - global_transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()


func move_enemy(delta):
	# Move toward player or along a predefined path
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()


func is_visible_line_of_sight() -> bool:
	var space_state = get_world_3d().direct_space_state
	var ray_params = PhysicsRayQueryParameters3D.create(
		camera.global_transform.origin, global_transform.origin
	)
	ray_params.exclude = [camera, self]  # Optional: ignore self/camera
	var result = space_state.intersect_ray(ray_params)

	return result.is_empty()


func is_seen_by_camera() -> bool:
	# 1. Check if enemy is in front of the camera
	var to_enemy = global_transform.origin - camera.global_transform.origin
	if camera.is_position_behind(global_transform.origin):
		return false

	# 2. Check angle between camera forward and direction to enemy
	var cam_forward = -camera.global_transform.basis.z
	var dot = cam_forward.normalized().dot(to_enemy.normalized())

	# If dot > cos(FOV / 2), then it's in field of view
	var fov_threshold = cos(deg_to_rad(camera.fov))
	return dot > fov_threshold and is_visible_line_of_sight()


func teleport_around_player():
	var nav_map = get_world_3d().navigation_map
	var player_pos = player.global_transform.origin
	var cam_forward = -camera.global_transform.basis.z.normalized()

	var current_pos = global_transform.origin
	var to_player = current_pos - player_pos
	to_player.y = 0
	var distance = to_player.length()

	var max_attempts = 20
	for i in range(max_attempts):
		var angle = randf_range(0, TAU)
		var offset = Vector3(cos(angle), 0, sin(angle)) * distance
		var candidate = player_pos + offset
		var nav_pos = NavigationServer3D.map_get_closest_point(nav_map, candidate)

		var dir_to_pos = (nav_pos - player_pos).normalized()
		var dot = cam_forward.dot(dir_to_pos)

		# dot > 0 = in front; dot < 0 = behind. Reject if too far in front (e.g. dot > 0.5)
		if (
			dot < 0.5
			and nav_pos.distance_to(player_pos) >= distance * 0.95
			and nav_pos.distance_to(player_pos) <= distance * 1.05
		):
			global_transform.origin = nav_pos
			agent.target_position = player.global_transform.origin
			print("Enemy teleported behind player to:", nav_pos)
			return

	print("Teleport failed: couldn't find a valid spot behind the player")
