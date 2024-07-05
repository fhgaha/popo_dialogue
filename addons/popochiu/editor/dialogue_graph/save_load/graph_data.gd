class_name GraphData extends Resource

class ToPopochiuDialogue:
	var callables: Array[Callable] = []
	var options  : Array[String]   = []

@export var connections: Array[Dictionary]
@export var nodes      : Array[NodeData]

var cur_node: NodeData
 
func handle(option: String = "", data: ToPopochiuDialogue = null) -> ToPopochiuDialogue:
	if !data: data = ToPopochiuDialogue.new()
	if !cur_node: cur_node = get_start_node()
	var from_node_cons: Array = connections.filter(
		func(cn): return cn["from_node"] == cur_node.name)
	if from_node_cons.size() == 0:
		#reached end
		data.callables.append(func(): await D.finish_dialog())
		return data
	
	cur_node = next(cur_node, option)
	
	#type matching not implemented >.<
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
	
	return data

func get_start_node() -> NodeData:
	assert(
		nodes.any(func(n: NodeData): return n is StartNodeData),
		"No start node created")
	return nodes.filter(func(n: NodeData): return n is StartNodeData)[0]

func next(node: NodeData, option: String = "") -> NodeData:
	var from_node_cons: Array = connections.filter(
		func(cn): return cn["from_node"] == node.name)
	
	match from_node_cons.size():
		0:
			push_error("This node does not have connections")
			return null
		1:
			var next_node_name: String = from_node_cons[0]["to_node"]
			var next_node: NodeData = nodes.filter(
				func(n): return n.name == next_node_name
			)[0]
			return next_node
		_:
			assert(!option.is_empty(), "Option should not be emtpy at this point")
			
			var idx: int = cur_node.data["options"].find(option)
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
