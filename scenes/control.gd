extends Control

@onready var dialogue_box: DialogueBox = $DialogueBox

func _on_button_pressed() -> void:
	dialogue_box.start('START')
