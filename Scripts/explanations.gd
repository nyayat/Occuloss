extends Node2D

@onready var ctx: Context = get_node("/root/PauseHistory")
@onready var timer: Timer = $Timer


func _on_timeout() -> void:
	timer.stop()
	ctx.switch_scene("res://Scenes/House.tscn")
