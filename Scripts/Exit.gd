extends CharacterBody3D

@onready var ctx: Context = get_node("/root/PauseHistory")
var player: CharacterBody3D
var detection_radius := 3.0  # You can tweak this value as needed


func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array


func _ready():
	for node in get_tree().get_nodes_in_group("Player"):
		if node is CharacterBody3D:
			player = node
			break


func _physics_process(delta):
	if caught():
		ctx.switch_scene("res://Scenes/VictoryMenu.tscn")


func caught() -> bool:
	if not player:
		return false
	var distance := global_transform.origin.distance_to(player.global_transform.origin)

	return distance < detection_radius
