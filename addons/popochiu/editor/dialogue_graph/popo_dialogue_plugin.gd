@tool
extends EditorPlugin

const DIALOGUE_GRAPH = preload("res://addons/popochiu/editor/dialogue_graph/graph.tscn")

var dialogue_graph: DialogueGraph
var window: Window

func _enter_tree() -> void:
	
	dialogue_graph = DIALOGUE_GRAPH.instantiate()
	window = Window.new()
	#window.popup_window = true
	window.close_requested.connect(func(): window.hide())
	var screen_size = DisplayServer.screen_get_size()
	window.size = Vector2i(screen_size.x - 200, screen_size.y - 200)
	window.keep_title_visible = true
	window.position = Vector2i(200/2, 200/2)
	window.hide()
	window.add_child(dialogue_graph)
	add_child(window)

func _exit_tree() -> void:
	if (is_instance_valid(window)):
		window.queue_free()

func _handles(object):
	return object is GraphData

func _edit(object):
	if (object is GraphData 
	&& is_instance_valid(dialogue_graph)
	&& is_instance_valid(window)):
		window.position = Vector2i(200/2, 200/2)
		dialogue_graph.res_path = object.resource_path
		dialogue_graph.load_data(object.resource_path)
		window.title = object.resource_name
		window.show()
