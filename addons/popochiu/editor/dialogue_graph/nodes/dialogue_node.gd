@tool
class_name DialogueNode extends PopoGraphNode

const OPTION_SCENE = preload("res://addons/popochiu/editor/dialogue_graph/dialogue_option.tscn")

@onready var options: VBoxContainer = $Options

var base_color: Color = Color.WHITE

func _ready() -> void:
	type = "dialogue"
	
	for opt: DialogueOption in options.get_children():
		if !opt.text_changed.is_connected(_on_option_text_changed):
			opt.text_changed.connect(_on_option_text_changed)
		if !opt.focus_exited.is_connected(_on_option_focus_exited):
			opt.focus_exited.connect(_on_option_focus_exited)

func add_empty_option():
	var opt = OPTION_SCENE.instantiate()
	options.add_child(opt)
	opt.text_changed.connect(_on_option_text_changed)
	opt.focus_exited.connect(_on_option_focus_exited)

func remove_last_option():
	remove_option(options.get_children()[-1])

func remove_option(option: DialogueOption):
	var opts: Array[Node] = options.get_children()
	assert(opts.size() > 1, "%s: Attempt to remove a dialogue option when there is only one option!" % self)
	
	option.queue_free()

func _on_option_text_changed(new_text: String, option: DialogueOption):
	#if !new_text.is_empty():
		#add_empty_option()
	pass

func _on_option_focus_exited():
	update_options()
	update_slots()

func update_options():
	for opt: DialogueOption in options.get_children():
		#print(opt.get_index(), ": ", opt.text)
		if opt.text.is_empty():
			opt.queue_free()
	add_empty_option()
	#print("----")

func update_slots():
	await get_tree().process_frame
	var opts = options.get_children() 
	if opts.size() == 1:
		set_slot(opts[0].get_index(), false, 0, base_color, true, 0, base_color)
		return
	
	for option: DialogueOption in opts:
		var enable_right_port : bool = !option.text.is_empty()
		set_slot(option.get_index(), false, 0, base_color, 
			enable_right_port, 0, base_color)
