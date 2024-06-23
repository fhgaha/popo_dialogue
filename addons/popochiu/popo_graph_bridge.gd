@tool
class_name PopoGraphBridge extends Node

#static func set_up_start_options(
	#pd:PopochiuDialog, 
	#graph: DialogueData, 
	#res:PopochiuDialog
	#) -> void:
	#var dlg:Dictionary = find_first_dialogue(graph.nodes)
	#var dlg_id :String     = dlg["k"]
	#var dlg_val:Dictionary = dlg["v"]
	##print(dlg_id, ": ", dlg_val)
	#
	#var opts: Array[PopochiuDialogOption] = []
	#for opt_id:int in dlg_val["options"]:
		#var opt_val = dlg_val["options"][opt_id]
		#var popo_opt := popo_opt(opt_val["text"], opt_val["text"])
		#print(opt_val["text"])
		#opts.append(popo_opt)
	#update_dialog(opts, res)
	#pass

static func find_first_dialogue(nodes: Dictionary) -> Dictionary:
	var start: String = find_start(nodes)
	assert(start != "")
	#print(start, " ", graph.nodes[start])
	
	var dlg:Dictionary = get_fist_dialogue_node(start, nodes)
	assert(len(dlg) != 0)
	#print(dlg_id, ": ", dlg_val)
	return dlg

#"options": { 
	#0: { 
		#"condition": {  }, 
		#"link": "END", 
		#"text": "" 
		#} 
	#}

static func get_fist_dialogue_node(start_id: String, nodes: Dictionary) -> Dictionary:
	var val:Dictionary = nodes[start_id]
	if val.has("dialogue"):
		return {"k": start_id, "v": val}
	if val.has("link") and val["link"].to_lower() == "end":
		printerr("PopoGraphBridge: couldnt find dialogue node!")
		return {}
	
	var next_id: String = val["link"]
	return get_fist_dialogue_node(next_id, nodes)

static func find_start(nodes: Dictionary) -> String:
	for k in nodes:
		var val:Dictionary = nodes[k]
		print(k, ": ", val)
		if val.has("start_id"):
			return k
	printerr("PopoGraphBridge: couldnt find start node!")
	return ""

#0_1: { "link": &"1_1", "offset": (-57, -198), "start_id": "sssssss" }
#1_1: { "dialogue": "st", "offset": (260, -220), "options": { 0: { "condition": {  }, "link": &"1_2", "text": "opt text" } }, "size": (300, 242), "speaker": "te" }
#1_2: { "dialogue": "end", "offset": (640, -200), "options": { 0: { "condition": {  }, "link": "END", "text": "" } }, "size": (300, 240), "speaker": "te" }

#example
#update_dialog([
	#opt("goodgood",   "Good, good"),
	#opt("policeman",  "I'm a policeman")
#])

static func update_dialog(array: Array[PopochiuDialogOption], res: PopochiuDialog) -> void:
	#var RES:PopochiuDialog = load("res://game/dialogs/working_class_woman_first/dialog_working_class_woman_first.tres")
	res.options.clear()
	res.options.append_array(array)

static func popo_opt(id: String, text: String, visible: bool = true) -> PopochiuDialogOption:
	var opt = PopochiuDialogOption.new()
	opt.id = id
	opt.text = text
	opt.visible = visible
	return opt
