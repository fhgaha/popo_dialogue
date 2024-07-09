@tool
class_name PopoGraphNode extends GraphNode

var offset: Vector2 = Vector2.ZERO

func as_node_data() -> NodeData:
	push_error("Interface method")
	return null

func load_data(data: NodeData) -> void:
	push_error("Interface method")
