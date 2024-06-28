@tool
class_name DialogueOption extends BoxContainer

signal text_changed(new_text: String, option: DialogueOption)

@onready var line_edit: LineEdit = $Text

var text : String: 
	get: 
		#if !is_node_ready(): await ready	#causes crash
		return line_edit.text if line_edit else ""
	set(val):
		if !is_node_ready(): await ready
		line_edit.text = val

func _on_text_changed(new_text: String) -> void:
	text_changed.emit(new_text, self)

func _on_text_focus_exited() -> void: 
	focus_exited.emit()
