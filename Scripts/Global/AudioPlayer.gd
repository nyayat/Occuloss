class_name Sound extends AudioStreamPlayer

#const menu_music = preload("res://Assets/Musics/menusong.wav")
const main_music = preload("res://Assets/Musics/maintheme.wav")

@onready var index = AudioServer.get_bus_index(bus)


func _ready() -> void:
	# Default volume
	set_volume(0.4)


## Play an audio stream.[br][br]
## Example usage: When the node enters the scene tree for the first time.
func _play_music(music: AudioStream) -> void:
	if stream == music:
		return

	stream = music
	if !playing:
		play()


func play_main_music() -> void:
	_play_music(main_music)
	pass


func play_music_menu() -> void:
	#_play_music(menu_music)
	pass


## Change the volume db
func set_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(index, linear_to_db(value))


## Get the volume db
func get_volume() -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(index))
