@tool
class_name SetNode extends PopoGraphNode

signal variables_request(sender: SetNode)
signal variable_selected(sender: SetNode, index: int)

@onready var variable: OptionButton = $BoxContainer/Variable
@onready var operator: OptionButton = $BoxContainer/Operator
@onready var value: LineEdit = $BoxContainer/Value

func as_node_data() -> NodeData:
	var data := SetNodeData.new()
	data.name     = name
	data.offset   = position_offset
	data.size     = size
	data.variable = variable.text
	data.operator = operator.text
	data.value    = value.text
	return data

func load_data(data: NodeData) -> void:
	if !is_node_ready(): await ready
	
	data = data as SetNodeData
	position_offset = data.offset
	name            = data.name
	title           = data.name
	variable.text   = data.variable
	operator.text   = data.operator
	value.text      = data.value

func _on_variable_pressed() -> void:
	variables_request.emit(self)

func set_up_variable(variables: Dictionary) -> void:
	#variables example:
	#{ "var1": { "type": 4, "value": "adasd" }, "var2": { "type": 2, "value": 11 }, "var6": { "type": 3, "value": 11.11 }, "var5": { "type": 1, "value": true } }
	variable.clear()

	for key in variables:
		variable.add_item(key, variables[key]["type"])

func clear_variable_button() -> void:
	variable.text = ""
	variable.selected = -1
