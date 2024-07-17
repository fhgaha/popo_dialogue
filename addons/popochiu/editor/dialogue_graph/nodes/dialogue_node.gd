@tool
class_name DialogueNode extends PopoGraphNode

const OPTION_SCENE = preload("res://addons/popochiu/editor/dialogue_graph/dialogue_option.tscn")

@onready var speaker_node: OptionButton = $"Slot_1/SpeakerContainer/Speaker"
@onready var dialogue: TextEdit = %Dialogue

var speaker: String:
	get: return speaker_node.text #can be empty string
	set(val):
		if !is_node_ready(): await ready
		speaker_node.text = val

var text: String:
	get: return dialogue.text
	set(val):
		if !is_node_ready(): await ready
		dialogue.text = val

var options: Array[DialogueOption]:
	get:
		var opts: Array[DialogueOption] = []
		opts.assign(get_children().slice(1))
		return opts

var base_color: Color = Color.WHITE

func _ready() -> void:
	for opt: DialogueOption in options:
		connect_option_signals(opt)

func connect_option_signals(option: DialogueOption) -> void:
	if !option.text_changed.is_connected(_on_option_text_changed):
		option.text_changed.connect(_on_option_text_changed)
	if !option.focus_exited.is_connected(_on_option_focus_exited):
		option.focus_exited.connect(_on_option_focus_exited)

func add_empty_option():
	var opt = OPTION_SCENE.instantiate()
	add_child(opt)
	opt.text_changed.connect(_on_option_text_changed)
	opt.focus_exited.connect(_on_option_focus_exited)

func remove_last_option():
	remove_option(options[-1])

func remove_option(option: DialogueOption):
	assert(options.size() > 1, "%s: Attempt to remove a dialogue option when there is only one option!" % self)
	option.queue_free()

func _on_option_text_changed(new_text: String, option: DialogueOption):
	pass

func _on_option_focus_exited():
	update_options()
	update_slots()

func update_options():
	for opt: DialogueOption in options:
		if opt.text.is_empty():
			opt.queue_free()
			await opt.tree_exited
	add_empty_option()
	update_slots()

func update_slots():
	if options.size() == 1:
		set_slot(options[0].get_index(), 
			false, 0, base_color, 
			true, 0, base_color)
		return
	
	for option: DialogueOption in options:
		if option.text.is_empty():
			set_slot(option.get_index(), 
				false, 0, base_color, 
				false, 0, base_color)
		else:
			var enable_right_port : bool = !option.text.is_empty()
			set_slot(option.get_index(), 
				false, 0, base_color, 
				enable_right_port, 0, base_color)

func _on_speaker_pressed() -> void:
	var path:= "res://game/characters/"
	assert(DirAccess.dir_exists_absolute(path), "No characters created!")
	
	speaker_node.clear()
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			speaker_node.add_item(file_name.to_pascal_case())
		file_name = dir.get_next()
	dir.list_dir_end()

func _on_speaker_item_selected(index: int) -> void:
	pass

func load_data(data: NodeData) -> void:
	if !is_node_ready(): await ready
	
	data = data as DialogueNodeData
	name            = data.name
	title           = data.name
	position_offset = data.offset
	size            = data.size
	speaker         = data.speaker_name
	text            = data.text   
	load_options(data.options)

func load_options(options_names: Array[String]):
	clear_options()
	for opt_text: String in options_names:
		var opt = OPTION_SCENE.instantiate()
		opt.text = opt_text
		add_child(opt)
		connect_option_signals(opt)
		options.append(opt)
		if !opt.is_node_ready(): await opt.ready
	if !is_node_ready(): await ready
	update_slots()

func clear_options():
	for opt: DialogueOption in get_children().filter(func(c): return c is DialogueOption):
		opt.free()
	options.clear()

func as_node_data() -> DialogueNodeData:
	var data := DialogueNodeData.new()
	data.name         = name
	data.offset       = position_offset
	data.size         = size
	data.speaker_name = speaker
	data.text         = text
	var opts : Array[String] = []
	opts.assign(options.map(func(opt): return opt.text))
	data.options      = opts
	return data
