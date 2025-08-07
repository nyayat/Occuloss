extends Node

@onready var audio_controller: Sound = get_node("/root/AudioPlayer")
@onready var ctx: Context = get_node("/root/PauseHistory")


func _ready() -> void:
	audio_controller.play_main_music()


func _input(event):
	if event.is_action_pressed("pause"):
		ctx.switch_scene("res://Scenes/PauseMenu.tscn", true)
