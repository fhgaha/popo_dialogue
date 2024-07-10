@tool
class_name DialogueGraph extends Control

const START_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/start_node.tscn")
const DIALOGUE_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/dialogue_node.tscn")

@onready var graph_edit: GraphEdit = $FilesAndGraphPanel/GraphEdit
@onready var add_node_menu: PopupMenu = $FilesAndGraphPanel/GraphEdit/AddNodeMenu
@onready var load_dialog: FileDialog = $FilesAndGraphPanel/LoadDialog
@onready var file_name_label: Label = $FilesAndGraphPanel/TopPanel/Group2/FileName

var res_path : String

func _ready() -> void:
	add_node_menu.hide()
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
	start_node.name = "StartNode"
	graph_edit.add_child(start_node)
	set_node_pos_to_mouse_pos(start_node)

func add_dialogue_node():
	#should manually set name of dialogue node otherwise graph edit messes up its connections, 
	#thinks node1 is node3 and etc. for some reason
	var dlg_node = DIALOGUE_NODE.instantiate()
	var dlg_nodes_count:int = graph_edit.get_children().filter(
		func(c): return c is DialogueNode).size()
	dlg_node.name = "DialogueNode" + str(dlg_nodes_count + 1)
	dlg_node.title = dlg_node.name
	graph_edit.add_child(dlg_node)
	set_node_pos_to_mouse_pos(dlg_node)

func set_node_pos_to_mouse_pos(node: GraphNode):
	node.set_position_offset((graph_edit.get_local_mouse_position() + graph_edit.scroll_offset) / graph_edit.zoom)

func _on_graph_edit_connection_request(
	from_node: StringName, from_port: int, to_node: StringName, to_port: int
	) -> void:
	#if graph_edit.get_node(str(from_node)) is StartNode:
		#for con: Dictionary in graph_edit.get_connection_list():
			#if con.to_node == to_node and con.to_port == to_port:
				#return
	graph_edit.connect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_disconnection_request(
	from_node: StringName, from_port: int, to_node: StringName, to_port: int
	) -> void:
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)

func _on_save_pressed() -> void:
	assert(!res_path.is_empty(), "DialogueGraph: resource_path is empty")
	save_data(res_path)

func save_data(save_path: String) -> void:
	var graph_data := GraphData.new()
	graph_data.resource_name = save_path.split('/', false)[-1]
	graph_data.take_over_path(save_path)
	
	graph_data.connections = graph_edit.get_connection_list()
	for node in graph_edit.get_children():
		if node is PopoGraphNode:
			var node_data = node.as_node_data()
			graph_data.nodes.append(node_data)
	if ResourceSaver.save(graph_data, save_path) == OK:
		#print("Graph saved")
		pass
	else:
		print("Error saving graph_data")

func _on_load_pressed() -> void:
	load_dialog.root_subfolder = "res://game/dialogs"
	load_dialog.show()

func _on_load_dialog_file_selected(path: String) -> void:
	load_data(path)

func load_data(file_path: String):
	res_path = file_path
	if ResourceLoader.exists(file_path):
		var graph_data = ResourceLoader.load(file_path)
		if graph_data is GraphData:
			init_graph(graph_data)
			file_name_label.text = graph_data.resource_name
		else:
			# Error loading data
			push_error("couldnt load data from %s", file_path)
	else:
		# File not found
		push_error("couldnt find file at %s", file_path)

func init_graph(graph_data: GraphData):
	await clear_graph()
	
	for data: NodeData in graph_data.nodes:
		# Get new node from factory autoload (singleton)
		var node: PopoGraphNode = GraphNodeFactory.create_node(data)
		node.load_data(data)
		graph_edit.add_child(node)
		if !node.is_node_ready(): await node.ready
	
	for con: Dictionary in graph_data.connections:
		var _err = graph_edit.connect_node(
			con.from_node, con.from_port, con.to_node, con.to_port)

func clear_graph():
	graph_edit.clear_connections()
	var nodes = graph_edit.get_children()
	for node in nodes:
		if node is GraphNode:
			node.queue_free()
			await node.tree_exited
