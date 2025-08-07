extends Node2D

@onready var audio_controller: Sound = get_node("/root/AudioPlayer")
@onready var ctx: Context = get_node("/root/PauseHistory")

@onready var volume_slider = $GridContainer/Volume/HSlider
@onready var volume_info = $GridContainer/Volume/Info


# Setup page
func _ready() -> void:
	volume_slider.value = audio_controller.get_volume()


# Handle navigation
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_return_button_pressed()


# Volume
func _on_volume_slider_changed(value: float) -> void:
	audio_controller.set_volume(volume_slider.value)
	volume_info.set_text(str(volume_slider.value * 100).pad_decimals(0) + "%")


func _on_fear_slider_changed(value: float) -> void:
	pass


func _on_fun_slider_changed(value: float) -> void:
	pass


func _on_return_button_pressed() -> void:
	ctx.return_to_previous()
