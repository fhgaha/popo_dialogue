@tool
class_name DialogueGraph extends Control

const START_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/start_node.tscn")
const DIALOGUE_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/dialogue_node.tscn")

@onready var graph_edit: GraphEdit = $GraphEdit
@onready var add_node_menu: PopupMenu = $GraphEdit/AddNodeMenu
@onready var save_dialog: FileDialog = $SaveDialog
@onready var load_dialog: FileDialog = $LoadDialog

func _ready() -> void:
	add_node_menu.hide()
	save_dialog.hide()
	var char_names:PackedStringArray = DirAccess.get_directories_at(
		"res://game/characters/")

func _on_add_pressed() -> void:
	var start_node = START_NODE.instantiate()
	graph_edit.add_child(start_node)

func _on_graph_edit_delete_nodes_request(nodes: Array[StringName]) -> void:
	for c: Node in graph_edit.get_children():
		if c is GraphNode and nodes.has(c.name):
			remove_connections_to_node(c)
			c.queue_free()

func remove_connections_to_node(node: PopoGraphNode):
	for con: Dictionary in graph_edit.get_connection_list():
		if con.to_node == node.name or con.from_node == node.name:
			graph_edit.disconnect_node(
				con.from_node, con.from_port, con.to_node, con.to_port)

func _on_graph_edit_popup_request(position: Vector2) -> void:
	#add_node_menu.position = position	#why is this position incorrect godot?
	add_node_menu.position = get_viewport().get_mouse_position()
	add_node_menu.show()

func _on_add_node_menu_id_pressed(id: int) -> void:
	match id:
		0: add_start_node()
		1: add_dialogue_node()

func add_start_node():
	var start_node = START_NODE.instantiate()
	graph_edit.add_child(start_node)
	set_node_pos_to_mouse_pos(start_node)

func add_dialogue_node():
	var dlg_node = DIALOGUE_NODE.instantiate()
	graph_edit.add_child(dlg_node)
	set_node_pos_to_mouse_pos(dlg_node)

func set_node_pos_to_mouse_pos(node: GraphNode):
	node.set_position_offset((graph_edit.get_local_mouse_position() + graph_edit.scroll_offset) / graph_edit.zoom)

func _on_graph_edit_connection_request(
	from_node: StringName, from_port: int, to_node: StringName, to_port: int
	) -> void:
	if graph_edit.get_node(str(from_node)) is StartNode:
		for con: Dictionary in graph_edit.get_connection_list():
			if con.to == to_node and con.to_port == to_port:
				return
	graph_edit.connect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_disconnection_request(
	from_node: StringName, from_port: int, to_node: StringName, to_port: int
	) -> void:
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)

func _on_save_pressed() -> void:
	#save_data("res://game/dialogs/first/test/")
	if !ResourceLoader.exists("res://game/dialogs/first/test/test.res"):
		save_data("res://game/dialogs/first/test/test.res")
	else:
		save_dialog.show()

func save_data(save_path: String) -> void:
	var graph_data := GraphData.new()
	graph_data.connections = graph_edit.get_connection_list()
	for node in graph_edit.get_children():
		if node is PopoGraphNode:
			var node_data := NodeData.new()
			node_data.name = node.name
			node_data.type = node.type
			node_data.offset = node.position_offset
			node_data.data = node.data
			graph_data.nodes.append(node_data)
	if ResourceSaver.save(graph_data, save_path) == OK:
		print("saved")
	else:
		print("Error saving graph_data")

func _on_save_dialog_file_selected(path: String) -> void:
	save_data(path)
	save_dialog.hide()

func _on_load_pressed() -> void:
	load_dialog.show()

func _on_load_dialog_file_selected(path: String) -> void:
	load_data(path)

func load_data(file_path: String):
	if ResourceLoader.exists(file_path):
		var graph_data = ResourceLoader.load(file_path)
		if graph_data is GraphData:
			init_graph(graph_data)
		else:
			# Error loading data
			pass
	else:
		# File not found
		pass

func init_graph(graph_data: GraphData):
	clear_graph()
	await get_tree().process_frame
	for node:NodeData in graph_data.nodes:
		# Get new node from factory autoload (singleton)
		var gnode:PopoGraphNode = GraphNodeFactory.create_node(node.type)
		gnode.position_offset = node.offset
		gnode.name = node.name
		graph_edit.add_child(gnode)
	for con in graph_data.connections:
		var _e = graph_edit.connect_node(
			con.from_node, con.from_port, con.to_node, con.to_port)

func clear_graph():
	graph_edit.clear_connections()
	var nodes = graph_edit.get_children()
	for node in nodes:
		if node is GraphNode:
			node.queue_free()
