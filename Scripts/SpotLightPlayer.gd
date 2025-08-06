extends SpotLight3D

const battery_max = 100.
var battery = 100.
var activate = true
var force_pause = false
var pause_delay := 2.5  # need to wait before start charging
var pause_timer := 0.0
var light_luminosity = 1.5


func _unhandled_input(event):
	if event.is_action_pressed("toggle_light"):
		activate = !activate
		print("Light toggled. Active:", activate)


func _physics_process(delta):
	if force_pause:  # if disc
		pause_timer -= delta
		if pause_timer <= 0.0:
			force_pause = false

	if !activate:
		charge(delta)
		self.light_energy = 0

	else:
		if battery > 0:
			self.light_energy = light_luminosity
		else:
			activate = false
		discharge(delta)


func pauseActivate():
	force_pause = true
	pause_timer = pause_delay


func discharge(delta):
	if force_pause:
		return
	battery -= delta
	print("décharge.... : ", battery)
	if (battery) <= 0:
		battery = 0
		print("plus de batterie... : ", battery)
		pauseActivate()


func charge(delta):
	if battery > battery_max:
		battery = battery_max
	if force_pause or battery == battery_max:
		return
	battery += delta / 2
	print("chargement : ", battery)
