@tool
extends PopochiuDialog

var nodes: Dictionary
var cur_node: Dictionary

#region Virtual ####################################################################################
func _on_start() -> void:
	# One can put here something to excecute before showing the dialog options.
	# E.g. Make the PC to look at the character which it will talk to, walk to
	# it, and say something (or make the character say something):
#	await C.player.face_clicked()
#	await C.player.say("Hi")
#	await C.Popsy.say("Oh! Hi...")
	# (!) It MUST always use an await
	#await E.get_tree().process_frame
	
	#await C.Main.say("I start the dialogue")
	
	
	#var characters = C._characters
	#var graph: DialogueData = load("res://game/dialogs/first/dialog_first_graph.tres")
	#nodes = graph.nodes
	##var res:= load("res://game/dialogs/first/dialog_first.tres")
	##PopoGraphBridge.set_up_start_options(self, graph, res)
	#var dlg_node = PopoGraphBridge.find_first_dialogue(nodes)
	#cur_node = dlg_node
	#
	#var opts: Array[PopochiuDialogOption] = []
	#for opt_id:int in cur_node["v"]["options"]:
		#var opt_val = cur_node["v"]["options"][opt_id]
		#var popo_opt := create_opt(opt_val["text"], opt_val["text"])
		## print(opt_val["text"])
		#opts.append(popo_opt)
	#update_options(opts)
	
	#var p = get_path()
	#print(p)
	pass


func _option_selected(opt: PopochiuDialogOption) -> void:
	# You can make the player character say the selected option with:
#	await D.say_selected()
	
	# Use match to check which option was selected and excecute something for
	# each one
	#match opt.id:
		#"Opt1":
			#turn_off_options(["Opt1", "Opt2"])
			#turn_on_options(["Opt3", "Opt4"])
		#"Opt2":
			#pass
		#"Opt3":
			#pass
		#"Opt4":
			#stop()
		#_:
			## By default close the dialog. Options won't show after calling
			## stop()
			#stop()
	
	#ask for options
	
	#set them up
	
	_show_options()


# Use this to save custom data for this PopochiuDialog when saving the game.
# The Dictionary must contain only JSON supported types: bool, int, float, String.
func _on_save() -> Dictionary:
	return {}


# Called when the game is loaded.
# This Dictionary should has the same structure you defined for the returned one in _on_save().
func _on_load(data: Dictionary) -> void:
	prints(data)


#endregion


func update_options(array: Array[PopochiuDialogOption]) -> void:
	options.clear()
	options.append_array(array)

func create_opt(id: String, text: String, visible: bool = true) -> PopochiuDialogOption:
	var opt = PopochiuDialogOption.new()
	opt.id = id
	opt.text = text
	opt.visible = visible
	return opt
