class_name StartNodeData extends NodeData

static func as_node_data(node: PopoGraphNode) -> NodeData:
	assert(node is StartNode, "Not StartNode")
	return null
