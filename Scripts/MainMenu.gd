extends GridContainer

@onready var switcher = get_node("/root/PauseHistory")


func _on_play_pressed() -> void:
	switcher.switch_scene("res://Scenes/House.tscn")


func _on_options_pressed() -> void:
	switcher.switch_scene("res://Scenes/Options.tscn")


func _on_quit_pressed() -> void:
	switcher.exit_game()
