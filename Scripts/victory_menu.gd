extends Node2D

@onready var ctx: Context = get_node("/root/PauseHistory")
@onready var btn: MenuButton = $Back


func _ready() -> void:
	btn.grab_focus()


func _on_back_pressed() -> void:
	ctx.clear_history()
	ctx.switch_scene("res://Scenes/MainMenu.tscn")
