extends Node2D

@onready var audio_controller: Sound = get_node("/root/AudioPlayer")
@onready var ctx: Context = get_node("/root/PauseHistory")

@onready var volume_slider = $GridContainer/Volume/HSlider
@onready var volume_info = $GridContainer/Volume/Info

@onready var peur_slider = $GridContainer/Peur/HSlider
@onready var peur_info = $GridContainer/Peur/Info

@onready var fun_slider = $GridContainer/Fun/HSlider
@onready var fun_info = $GridContainer/Fun/Info


# Setup page
func _ready() -> void:
	volume_slider.set_value(audio_controller.get_volume())
	_on_fear_slider_changed(peur_slider.get_value())
	_on_fun_slider_changed(fun_slider.get_value())


# Handle navigation
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_return_button_pressed()


# Volume
func _on_volume_slider_changed(value: float) -> void:
	audio_controller.set_volume(value)
	volume_info.set_text(str(value * 100).pad_decimals(0) + "%")


func _on_fear_slider_changed(value: float) -> void:
	peur_info.set_text(str(value).pad_decimals(0) + "%")


func _on_fun_slider_changed(value: float) -> void:
	fun_info.set_text(str(value).pad_decimals(0) + "%")


func _on_return_button_pressed() -> void:
	ctx.return_to_previous()
