@tool
class_name GraphNodeFactory extends Node

const START_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/start_node.tscn")
const DIALOGUE_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/dialogue_node.tscn")

static func create_node(type: String) -> PopoGraphNode:
	match type:
		"start":
			return START_NODE.instantiate()
		"dialogue":
			return DIALOGUE_NODE.instantiate()
		_:
			push_error("GraphNodeFactory: no such graph node type as " + type)
			return null
