@tool
class_name DialogueOption extends BoxContainer

signal text_changed(new_text: String, option: DialogueOption)

@onready var line_edit: LineEdit = $Text

var text : String: 
	get: return line_edit.text

func _on_text_changed(new_text: String) -> void:
	#line_edit.text = new_text
	text_changed.emit(new_text, self)

func _on_text_focus_exited() -> void: 
	focus_exited.emit()
