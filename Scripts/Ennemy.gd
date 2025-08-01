extends CharacterBody3D

@export var speed: float = 5.0
@export var player: CharacterBody3D
@export var camera: Camera3D

var agent: NavigationAgent3D

func _ready():
	agent = $NavigationAgent3D
	agent.target_position = global_transform.origin  # Stay still initially
	#player = get_node("FPPlayer")
	#camera = get_node("Camera3D")

func _physics_process(delta):
	# Update target if enemy is not seen
	if not is_seen_by_camera():
		agent.target_position = player.global_transform.origin
		move_along_path(delta)
	else:
		velocity = Vector3.ZERO
		move_and_slide()
		
func move_along_path(delta):
	if agent.is_navigation_finished():
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
	var ray_params = PhysicsRayQueryParameters3D.create(camera.global_transform.origin,global_transform.origin)
	ray_params.exclude = [camera, self] # Optional: ignore self/camera
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
	var fov_threshold = cos(deg_to_rad(camera.fov ))
	return dot > fov_threshold and is_visible_line_of_sight()
