class_name GraphData extends Resource

class ToPopochiuDialogue:
	var callables: Array[Callable] = []
	var options  : Array[String]   = []

@export var scroll_offset : Vector2
@export var connections   : Array[Dictionary]
@export var nodes         : Array[NodeData]
@export var variables     : Dictionary

var cur_node: NodeData
 
func handle(option: String = "", data: ToPopochiuDialogue = null) -> ToPopochiuDialogue:
	if !data: data = ToPopochiuDialogue.new()
	if !cur_node: cur_node = get_start_node()
	var from_node_conections: Array = connections.filter(
		func(cn): return cn["from_node"] == cur_node.name)
	if from_node_conections.size() == 0:
		#reached end
		cur_node = null
		data.callables.append(func(): await D.finish_dialog())
		return data
	cur_node = next(cur_node, option)
	
	#type matching not implemented
	if   cur_node is StartNodeData:
		pass
	elif cur_node is DialogueNodeData:
		cur_node = cur_node as DialogueNodeData
		var speaker_name: String = cur_node.speaker_name
		var character: PopochiuCharacter = C._characters[speaker_name]
		var text: String = cur_node.text
		if !text.is_empty():
			data.callables.append(func(): return await character.say(text))
		var options: Array[String] = cur_node.options
		match options.size():
			0:
				push_error("Here options should not be empty")
			1: #no need to click an option, go forward
				handle("", data)
			_: #player needs to click an option
				data.options = options
	elif cur_node is ConditionNodeData:
		handle("", data)
	elif cur_node is SetNodeData:
		handle("", data)
	elif cur_node is CallNodeData:
		cur_node = cur_node as CallNodeData
		# execure text
		D.current_dialog.evaluate(cur_node.text)
		handle("", data)
	
	return data

func get_start_node() -> NodeData:
	assert(
		nodes.any(func(n: NodeData): return n is StartNodeData),
		"No start node created"
	)
	return nodes.filter(func(n: NodeData): return n is StartNodeData)[0]

func next(node: NodeData, option: String = "") -> NodeData:
	var from_node_cons: Array = connections.filter(
		func(cn): return cn["from_node"] == node.name)
	match from_node_cons.size():
		0:
			push_error("This node does not have connections")
			return null
		1:
			if cur_node is SetNodeData:
				cur_node = cur_node as SetNodeData
				#set variable
				var variable_val = variables[cur_node.variable]["value"]
				var value
				match variables[cur_node.variable]["type"]:
					TYPE_STRING:
						value = cur_node.value as String
					TYPE_INT:
						value = cur_node.value.to_int()
					TYPE_FLOAT:
						value = cur_node.value.to_float()
					TYPE_BOOL:
						value = true if cur_node.value.to_lower() == "true" else false
					_:
						pass
				match cur_node.operator:
					"=" : variables[cur_node.variable]["value"] = value
					"+=": variables[cur_node.variable]["value"] += value
					"-=": variables[cur_node.variable]["value"] -= value
					"*=": variables[cur_node.variable]["value"] *= value
					"/=": variables[cur_node.variable]["value"] /= value
					_: pass
			
			#dialogue node with no options entered
			var next_node_name: String = from_node_cons[0]["to_node"]
			var next_node: NodeData = nodes.filter(
				func(n): return n.name == next_node_name
			)[0]
			return next_node
		2:
			assert(cur_node is ConditionNodeData, 
			"Two connections from node but the node is not ConditionNodeData")
			
			cur_node = cur_node as ConditionNodeData
			
			#variables:
			#{ "var1": { "type": 4, "value": "adasd" }, "var2": { "type": 2, "value": 11 }, "var3": { "type": 3, "value": 11.11 }, "var4": { "type": 1, "value": true } }
			
			#evaluate condition
			var value1: Variant = variables[cur_node.value1]["value"]
			var value2: Variant
			
			match variables[cur_node.value1]["type"]:
				TYPE_STRING:
					value1 = (value1 as String).to_lower()
					value2 = (cur_node.value2 as String).to_lower()
				TYPE_INT:
					value2 = cur_node.value2.to_int()
				TYPE_FLOAT:
					value2 = cur_node.value2.to_float()
				TYPE_BOOL:
					value2 = true if cur_node.value2.to_lower() == "true" else false
				_:
					pass
			prints(type_string(typeof(value1)), type_string(typeof(value2)))
			var condition_result: bool
			match cur_node.operator:
				"==": condition_result = value1 == value2
				"!=": condition_result = value1 != value2
				">" : condition_result = value1 > value2
				"<" : condition_result = value1 < value2
				">=": condition_result = value1 >= value2
				"<=": condition_result = value1 <= value2
				_: pass
			
			var con_idx : int = 0 if condition_result else 1
			var next_node_name: String = from_node_cons.filter(func(c: Dictionary):
				return c["from_port"] == con_idx)[0]["to_node"]
			var next_node: NodeData = nodes.filter(
				func(n): return n.name == next_node_name
			)[0]
			return next_node
		_:
			assert(!option.is_empty(), "Option should not be emtpy at this point")
			
			var idx: int = cur_node.options.find(option)
			if idx == -1:
				push_error("node %s has no option %s" % cur_node, option)
			
			var con: Dictionary = from_node_cons.filter(
				func(cn: Dictionary):
					return cn["from_port"] == idx
			)[0]
			var next_node = nodes.filter(
				func(n: NodeData):
					return n.name == str(con["to_node"])
			)[0]
			return next_node
	
	pass
