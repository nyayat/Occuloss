extends GridContainer

@onready var audio_controller: Sound = get_node("/root/AudioPlayer")
@onready var ctx: Context = get_node("/root/PauseHistory")
@onready var playbtn: MenuButton = $Play


func _ready() -> void:
	playbtn.grab_focus()
	audio_controller.play_music_menu()


func _on_play_pressed() -> void:
	ctx.switch_scene("res://Scenes/House.tscn")


func _on_options_pressed() -> void:
	ctx.switch_scene("res://Scenes/OptionsMenu.tscn")


func _on_quit_pressed() -> void:
	ctx.exit_game()


func _on_credits_pressed() -> void:
	ctx.switch_scene("res://Scenes/Credits.tscn")
