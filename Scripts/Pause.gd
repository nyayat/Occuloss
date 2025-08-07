extends Node2D

@onready var ctx: Context = get_node("/root/PauseHistory")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		ctx.return_to_previous(true)
