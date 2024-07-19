@tool
extends "res://addons/popochiu/editor/main_dock/popochiu_row/object_row/popochiu_object_row.gd"

enum DialogOptions {
	DELETE = MenuOptions.DELETE,
	ADD_TO_CORE = Options.ADD_TO_CORE,
	USE_GRAPH,
}

const TAG_ICON = preload("res://addons/popochiu/editor/dialogue_graph/icons/GraphEditGreenDark.svg")
const STATE_TEMPLATE = "res://addons/popochiu/engine/templates/dialog_template.gd"
const STATE_GRAPH_TEMPLATE = "res://addons/popochiu/engine/templates/dialog_graph_template.gd"

var use_graph := false : set = set_use_graph

#region Godot ######################################################################################
func _ready() -> void:
	super()
	
	# Assign icons
	tag.texture = TAG_ICON

#endregion

#region Virtual ####################################################################################
func _get_state_template() -> Script:
	return load(STATE_GRAPH_TEMPLATE)


func _clear_tag() -> void:
	if use_graph:
		use_graph = false

#endregion

#region SetGet #####################################################################################
func set_use_graph(value: bool) -> void:
	use_graph = value
	
	PopochiuEditorHelper.signal_bus.dialog_using_graph_changed.emit(name, use_graph)
	
	tag.visible = value
	menu_popup.set_item_text(
		menu_popup.get_item_index(DialogOptions.USE_GRAPH),
		"Use Script" if value else "Use Graph"
	)

#endregion

#region Private ####################################################################################
func _get_menu_cfg() -> Array:
	return [
		{
			id = DialogOptions.USE_GRAPH,
			icon = TAG_ICON,
			label = "Use Graph",
		},
	] + super()


func _menu_item_pressed(id: int) -> void:
	match id:
		DialogOptions.USE_GRAPH:
			use_graph = !use_graph
		_:
			super(id)


func _remove_from_core() -> void:
	# Delete the object from Popochiu
	PopochiuResources.remove_autoload_obj(PopochiuResources.D_SNGL, name)
	PopochiuResources.erase_data_value("dialogs", str(name))
	PopochiuResources.erase_data_value("use_grpah", str(name))
	
	# Continue with the deletion flow
	super()


#endregion
