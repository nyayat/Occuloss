extends Node2D

@onready var ctx: Context = get_node("/root/PauseHistory")
@onready var text = $RichTextLabel


func load_from_file(path: NodePath) -> String:
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	return content


func _ready() -> void:
	text.clear()
	text.add_text(load_from_file("res://Credits.md"))


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_menu_button_pressed()


func _on_menu_button_pressed() -> void:
	ctx.return_to_previous()
