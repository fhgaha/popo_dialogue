@tool
class_name GraphNodeFactory extends Node

const START_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/start_node.tscn")
const DIALOGUE_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/dialogue_node.tscn")
const CONDITION_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/condition_node.tscn")
const SET_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/set_node.tscn")
const TEST_GRAPH_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/test_graph_node.tscn")
const CALL_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/call_node.tscn")

static func create_node(node: NodeData) -> PopoGraphNode:
	if node is StartNodeData:
		return create_start_node()
	elif node is DialogueNodeData:
		return create_dialogue_node()
	elif node is ConditionNodeData:
		return create_condition_node()
	elif node is SetNodeData:
		return create_set_node()
	elif node is CallNodeData:
		return create_call_node()
	#elif node is TestGraphNodeData:
		#return create_test_node()
	else:
		push_error("GraphNodeFactory: no such graph node type as " + type_string(typeof(node)))
		return null

static func create_start_node()    : return START_NODE.instantiate()
static func create_dialogue_node() : return DIALOGUE_NODE.instantiate()
static func create_condition_node(): return CONDITION_NODE.instantiate()
static func create_set_node()      : return SET_NODE.instantiate()
static func create_call_node()     : return CALL_NODE.instantiate()
static func create_test_node()     : return TEST_GRAPH_NODE.instantiate()
