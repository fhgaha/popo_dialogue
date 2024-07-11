@tool
class_name ConditionNode extends PopoGraphNode

signal variables_request(sender: ConditionNode, value_button: OptionButton)

@onready var value1  : OptionButton = $VBoxContainer/Value1
@onready var operator: OptionButton = $VBoxContainer/Operator
@onready var value2  : OptionButton = $VBoxContainer/Value2

func as_node_data() -> NodeData:
	var data := ConditionNodeData.new()
	data.name     = name
	data.offset   = position_offset
	data.value1   = value1.selected
	data.operator = operator.selected
	data.value2   = value2.selected
	return data

func load_data(data: NodeData) -> void:
	if !is_node_ready(): await ready
	
	data = data as ConditionNodeData
	position_offset   = data.offset
	name              = data.name
	title             = data.name
	value1.selected   = data.value1
	operator.selected = data.operator
	value2.selected   = data.value2

func _on_value_1_pressed() -> void:
	variables_request.emit(self, value1)

func _on_value_2_pressed() -> void:
	variables_request.emit(self, value2)

func set_up_value(value_button: OptionButton, variables: Dictionary) -> void:
	#variables example
	#{ "var1": { "type": 4, "value": "adasd" }, "var2": { "type": 2, "value": 11 }, "var6": { "type": 3, "value": 11.11 }, "var5": { "type": 1, "value": true } }
	value_button.clear()
	
	for key in variables:
		value_button.add_item(key, variables[key]["type"])
	pass
