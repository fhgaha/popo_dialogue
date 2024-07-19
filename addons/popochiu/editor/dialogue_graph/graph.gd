@tool
class_name DialogueGraph extends Control

@onready var graph_edit: GraphEdit = $HSplitContainer/GraphPanel/GraphEdit
@onready var add_node_menu: PopupMenu = $HSplitContainer/GraphPanel/GraphEdit/AddNodeMenu
@onready var load_dialog: FileDialog = $HSplitContainer/GraphPanel/LoadDialog
@onready var file_name_label: Label = $HSplitContainer/MarginContainer/Data/FileName
@onready var variables: VariablesPanel = $HSplitContainer/MarginContainer/Data/VariablesPanel

var res_path : String

var editor_settings : EditorSettings
var base_color : Color

func _ready() -> void:
	add_node_menu.hide()
	
	if !Engine.is_editor_hint(): return
	editor_settings = EditorInterface.get_editor_settings()
	editor_settings.settings_changed.connect(update_slots_color)
	
	variables.modified.connect(_on_variables_modified)
	variables.amount_changed.connect(_on_variables_amount_changed)
	
	#to stop EditorTheme error
	$HSplitContainer.theme = Theme.new()

func _on_add_pressed() -> void:
	#var start_node = START_NODE.instantiate()
	#graph_edit.add_child(start_node)
	pass

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
		2: add_condition_node()
		3: add_set_node()
		4: add_call_node()
		1000: add_test_node()

func add_start_node() -> void:
	var start_node = GraphNodeFactory.create_start_node()
	start_node.name = "StartNode"
	graph_edit.add_child(start_node)
	set_node_pos_to_mouse_pos(start_node)
	update_slots_color([start_node])

func add_dialogue_node() -> void:
	#should manually set name of dialogue node otherwise graph edit messes up its connections, 
	#thinks node1 is node3 and etc. for some reason
	var node = GraphNodeFactory.create_dialogue_node()
	var same_type_node_count:int = graph_edit.get_children().filter(
		func(c): return c is DialogueNode).size()
	node.name = "DialogueNode" + str(same_type_node_count + 1)
	node.title = node.name
	graph_edit.add_child(node)
	set_node_pos_to_mouse_pos(node)
	update_slots_color([node])

func add_condition_node() -> void:
	var node = GraphNodeFactory.create_condition_node()
	var same_type_node_count:int = graph_edit.get_children().filter(
		func(c): return c is ConditionNode).size()
	node.name = "ConditionNode" + str(same_type_node_count + 1)
	node.title = node.name
	
	node.variables_request.connect(_on_condition_node_variables_request)
	graph_edit.add_child(node)
	set_node_pos_to_mouse_pos(node)
	update_slots_color([node])

func add_set_node() -> void:
	var node = GraphNodeFactory.create_set_node()
	var same_type_node_count:int = graph_edit.get_children().filter(
		func(c): return c is SetNode).size()
	node.name = "SetNode" + str(same_type_node_count + 1)
	node.title = node.name
	node.variables_request.connect(_on_set_node_variables_request)
	graph_edit.add_child(node)
	set_node_pos_to_mouse_pos(node)
	update_slots_color([node])

func add_call_node() -> void:
	var node = GraphNodeFactory.create_call_node()
	#node.name = "CallNode"
	graph_edit.add_child(node)
	set_node_pos_to_mouse_pos(node)
	update_slots_color([node])

func add_test_node() -> void:
	var node = GraphNodeFactory.create_test_node()
	graph_edit.add_child(node)
	set_node_pos_to_mouse_pos(node)
	update_slots_color([node])

func set_node_pos_to_mouse_pos(node: GraphNode):
	node.set_position_offset((graph_edit.get_local_mouse_position() + graph_edit.scroll_offset) / graph_edit.zoom)

func _on_graph_edit_connection_request(
	from_node: StringName, from_port: int, 
	to_node: StringName, to_port: int) -> void:
	graph_edit.connect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_disconnection_request(
	from_node: StringName, from_port: int, to_node: StringName, to_port: int
	) -> void:
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)

func _on_save_pressed() -> void:
	assert(!res_path.is_empty(), "DialogueGraph: resource_path is empty")
	save_data(res_path)
	load_data(res_path)

func save_data(save_path: String) -> void:
	var graph_data := GraphData.new()
	graph_data.resource_name = save_path.split('/', false)[-1]
	graph_data.take_over_path(save_path)
	graph_data.scroll_offset = graph_edit.scroll_offset
	
	graph_data.connections = graph_edit.get_connection_list()
	for node in graph_edit.get_children():
		if node is TestGraphNode: continue
		if node is PopoGraphNode:
			var node_data = node.as_node_data()
			graph_data.nodes.append(node_data)
	
	graph_data.variables = variables.get_data()
	
	assert(
		ResourceSaver.save(graph_data, save_path) == OK,
		"Error saving graph data"
	)

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
			#awaiting for connections to load so update_slots_color() would work
			await init_graph(graph_data)
			file_name_label.text = graph_data.resource_name
		else:
			# Error loading data
			push_error("couldnt load data from %s", file_path)
	else:
		# File not found
		push_error("couldnt find file at %s", file_path)
	
	update_slots_color()

func init_graph(graph_data: GraphData):
	await clear_graph()
	
	for data: NodeData in graph_data.nodes:
		# Get new node from factory autoload (singleton)
		var node: PopoGraphNode = GraphNodeFactory.create_node(data)
		node.load_data(data)
		graph_edit.add_child(node)
		if !node.is_node_ready(): await node.ready
		if node is ConditionNode:
			var cn = node as ConditionNode
			cn.variables_request.connect(_on_condition_node_variables_request)
		if node is SetNode:
			var sn = node as SetNode
			sn.variables_request.connect(_on_set_node_variables_request)
	
	for con: Dictionary in graph_data.connections:
		var _err = graph_edit.connect_node(
			con.from_node, con.from_port, con.to_node, con.to_port)
	
	variables.load_data(graph_data.variables)
	graph_edit.scroll_offset = graph_data.scroll_offset

func clear_graph():
	graph_edit.clear_connections()
	var nodes = graph_edit.get_children()
	for node in nodes:
		if node is GraphNode:
			node.queue_free()
			await node.tree_exited

func update_slots_color(nodes : Array = graph_edit.get_children()):
	if not editor_settings: return
	
	const light_color := Color.WHITE
	const dark_color := Color.BLACK
	base_color = editor_settings.get_setting('interface/theme/base_color')
	base_color = light_color if base_color.v < 0.5 else dark_color
	
	for node in nodes:
		if not node is GraphNode: continue
		
		for i in range(node.get_child_count()):
			node = node as GraphNode
			var enabled_left : bool = node.is_slot_enabled_left(i)
			var enabled_right : bool = node.is_slot_enabled_right(i)
			var color_left : Color = node.get_slot_color_left(i)
			if color_left.is_equal_approx(light_color) or color_left.is_equal_approx(dark_color): 
				color_left = base_color
			var color_right : Color = node.get_slot_color_right(i)
			if color_right.is_equal_approx(light_color) or color_right.is_equal_approx(dark_color): 
				color_right = base_color
			node.set_slot(i, enabled_left, 0, color_left, enabled_right, 0, color_right)
		
		if 'base_color' in node: node.base_color = base_color

func _on_condition_node_variables_request(sender: ConditionNode) -> void:
	sender.set_up_value_items(variables.get_data())

func _on_set_node_variables_request(sender: SetNode) -> void:
	sender.set_up_variable(variables.get_data())

func _on_variables_modified():
	#prints("variables modified")
	pass

func _on_variables_amount_changed(var_name: String, var_was_added: bool) -> void:
	if !var_was_added:
		for cn: ConditionNode in graph_edit.get_children().filter(
			func(c): return c is ConditionNode):
			if cn.value1.text == var_name:
				cn.erase_value1()
		
		for sn: SetNode in graph_edit.get_children().filter(
			func(c): return c is SetNode):
			if sn.variable.text == var_name:
				sn.clear_variable_button()
