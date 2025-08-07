extends Node2D

@onready var ctx: Context = get_node("/root/PauseHistory")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# TODO: Apply a filter to the sound to differentiate it from the game


func _input(event):
	if event.is_action_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		# TODO: Remove the applied sound filter
		ctx.return_to_previous(true)


func _on_menu__return_button_pressed() -> void:
	ctx.clear_history()
	ctx.switch_scene("res://Scenes/MainMenu.tscn")
