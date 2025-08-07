extends ColorRect


func _ready():
	update_size()


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		update_size()


func update_size():
	size = get_viewport().size
