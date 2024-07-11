@tool
class_name StartNode extends PopoGraphNode

func _ready() -> void:
	pass

func as_node_data() -> StartNodeData:
	var data := StartNodeData.new()
	data.name = name
	data.offset = position_offset
	return data

func load_data(data: NodeData) -> void:
	if !is_node_ready(): await ready
	
	position_offset = data.offset
	name            = data.name
	title           = data.name
