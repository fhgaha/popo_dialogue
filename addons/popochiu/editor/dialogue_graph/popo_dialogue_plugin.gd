@tool
extends EditorPlugin

const DIALOGUE_GRAPH = preload("res://addons/popochiu/editor/dialogue_graph/graph.tscn")

var dialogue_graph: DialogueGraph

func _enter_tree() -> void:
	# ---- Add dialogue graph on bottom panel
	dialogue_graph = DIALOGUE_GRAPH.instantiate()
	add_control_to_bottom_panel(dialogue_graph, "Popo Dialogue")

func _exit_tree() -> void:
	if is_instance_valid(dialogue_graph):
		remove_control_from_bottom_panel(dialogue_graph)
		dialogue_graph.queue_free()
	pass

# ---- Two methods below allow opening GraphData res in Popo Dialogue ---------------

func _handles(object):
	return object is GraphData

func _edit(object):
	if object is GraphData and is_instance_valid(dialogue_graph):
		dialogue_graph.res_path = object.resource_path
		dialogue_graph.load_data(object.resource_path)
		make_bottom_panel_item_visible(dialogue_graph)
