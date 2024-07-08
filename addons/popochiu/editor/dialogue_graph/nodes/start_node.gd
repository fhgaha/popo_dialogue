@tool
class_name StartNode extends PopoGraphNode

func _ready() -> void:
	name = "StartNode"

func as_node_data() -> StartNodeData:
	var data := StartNodeData.new()
	data.name = name
	data.offset = position_offset
	return data

func load_data(node: NodeData) -> void:
	pass
