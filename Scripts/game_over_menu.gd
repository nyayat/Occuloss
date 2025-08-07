extends Node2D

@onready var ctx: Context = get_node("/root/PauseHistory")
@onready var btn: MenuButton = $Back


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	btn.grab_focus()


func _on_back_pressed() -> void:
	ctx.clear_history()
	ctx.switch_scene("res://Scenes/MainMenu.tscn")
