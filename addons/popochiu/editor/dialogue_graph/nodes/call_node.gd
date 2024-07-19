@tool
class_name CallNode extends PopoGraphNode

@onready var code_edit: TextEdit = $Slot2/CodeEdit

func as_node_data() -> NodeData:
	var data := CallNodeData.new()
	data.name     = name
	data.offset   = position_offset
	data.size     = size
	data.text     = code_edit.text
	return data

func load_data(data: NodeData) -> void:
	if !is_node_ready(): await ready
	
	data = data as CallNodeData
	name            = data.name
	title           = data.name
	position_offset = data.offset
	size            = data.size
	code_edit.text  = data.text
