@tool
class_name VariablesPanel extends Node

signal modified

const VARIABLE_ITEM_SCENE = preload("res://addons/popochiu/editor/dialogue_graph/variables_panel/variable_item.tscn")

@onready var var_container: VBoxContainer = $ScrollContainer/VBoxContainer

func get_data() -> Dictionary:
	var dict := {}
	for child in var_container.get_children():
		if child is VariableItem:
			var var_name = child.get_var_name()
			if var_name != '':
				dict[var_name] = child.get_data()
	return dict

func load_data(dict : Dictionary) -> void:
	# remove old variables
	clear()
	
	# add values
	for var_name in dict:
		add_variable(var_name, dict[var_name])

## clear variable list
func clear() -> void:
	for child in var_container.get_children():
		if child is HBoxContainer:
			child.queue_free()

## add new variable item to the list
func add_variable(
	new_name:= '', 
	data:= {'type': TYPE_STRING, 'value': ''}, 
	to_idx:= -1) -> VariableItem:
	var new_variable := VARIABLE_ITEM_SCENE.instantiate()
	var_container.add_child(new_variable, true)
	
	if to_idx > -1:
		var_container.move_child(new_variable, to_idx)
	
	new_variable.load_data(new_name, data)
	new_variable.modified.connect(_on_modified)
	new_variable.delete_requested.connect(_on_delete_requested)
	
	return new_variable

## remove the variable with at the given index (idx)
func remove_variable(idx : int) -> void:
	var variable = var_container.get_child(idx)
	variable.queue_free()
	_on_modified()

func get_variable(var_name : String) -> VariableItem:
	for child in var_container.get_children():
		if child is VariableItem and child.get_var_name() == var_name:
			return child
	
	printerr('Variable not found : ', var_name)
	return null

func get_value(var_name : String):
	return get_variable(var_name).get_value()

func set_value(var_name : String, value) -> void:
	if var_name == '':
		return
	var variable = get_variable(var_name)
	if not variable: return
	variable.set_value(value)

func _on_add_pressed() -> void:
	add_variable()

func _on_delete_requested(variable : BoxContainer) -> void:
	variable.queue_free()
	
	#var idx := variable.get_index()
	#undo_redo.create_action('Delete variable')
	#undo_redo.add_do_method(var_container, 'remove_child', variable)
	#undo_redo.add_do_method(self, '_on_modified')
	#undo_redo.add_undo_method(self, '_on_modified')
	#undo_redo.add_undo_method(var_container, 'add_child', variable)
	#undo_redo.add_undo_method(var_container, 'move_child', variable, idx)
	#undo_redo.add_undo_reference(variable)
	#undo_redo.commit_action()

func _on_modified(_a= 0, _b= 0) -> void:
	modified.emit()
