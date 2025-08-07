extends Node2D

@onready var audio_controller: Sound = get_node("/root/AudioPlayer")
@onready var ctx: Context = get_node("/root/PauseHistory")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	audio_controller.enable_pause_filter()


func _input(event):
	if event.is_action_pressed("pause"):
		_on_game_return_pressed()


func _on_menu__return_button_pressed() -> void:
	ctx.clear_history()
	ctx.switch_scene("res://Scenes/MainMenu.tscn")


func _on_game_return_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	audio_controller.disable_pause_filter()
	ctx.return_to_previous(true)
