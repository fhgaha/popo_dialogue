@tool
class_name GraphNodeFactory extends Node

const START_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/start_node.tscn")
const DIALOGUE_NODE = preload("res://addons/popochiu/editor/dialogue_graph/nodes/dialogue_node.tscn")

static func create_node(type: PopoGraphNode.Type) -> PopoGraphNode:
	match type:
		PopoGraphNode.Type.start:
			return START_NODE.instantiate()
		PopoGraphNode.Type.dialogue:
			return DIALOGUE_NODE.instantiate()
		_:
			push_error("GraphNodeFactory: no such graph node type as " + str(type))
			return null
