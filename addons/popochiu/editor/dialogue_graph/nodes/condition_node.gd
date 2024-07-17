@tool
class_name ConditionNode extends PopoGraphNode

signal variables_request(sender: ConditionNode)

@onready var value1  : OptionButton = $VBoxContainer/Value1
@onready var operator: OptionButton = $VBoxContainer/Operator
@onready var value2  : LineEdit = $VBoxContainer/Value2

func as_node_data() -> NodeData:
	var data := ConditionNodeData.new()
	data.name     = name
	data.offset   = position_offset
	data.size     = size
	data.value1   = value1.text
	data.operator = operator.text
	data.value2   = value2.text
	return data

func load_data(data: NodeData) -> void:
	if !is_node_ready(): await ready
	
	data = data as ConditionNodeData
	name            = data.name
	title           = data.name
	position_offset = data.offset
	size            = data.size
	value1.text     = data.value1
	operator.text   = data.operator
	value2.text     = data.value2

func _on_value_1_pressed() -> void:
	variables_request.emit(self)

func set_up_value_items(variables: Dictionary) -> void:
	#variables example:
	#{ "var1": { "type": 4, "value": "adasd" }, "var2": { "type": 2, "value": 11 }, "var6": { "type": 3, "value": 11.11 }, "var5": { "type": 1, "value": true } }
	value1.clear()

	for key in variables:
		value1.add_item(key, variables[key]["type"])

func _on_value_1_item_selected(index: int) -> void:
	pass

func erase_value1() -> void:
	value1.text = ""
	value1.selected = -1
