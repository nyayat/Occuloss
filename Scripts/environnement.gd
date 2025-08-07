extends Node3D


func _init() -> void:
	var waiting = get_children()
	while not waiting.is_empty():
		var node = waiting.pop_back() as Node
		waiting.append_array(node.get_children())
		var mesh = node as MeshInstance3D
		mesh.create_trimesh_collision()
