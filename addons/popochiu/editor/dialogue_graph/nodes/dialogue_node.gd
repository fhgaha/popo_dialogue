@tool
class_name DialogueNode extends PopoGraphNode

const OPTION_SCENE = preload("res://addons/popochiu/editor/dialogue_graph/dialogue_option.tscn")

@onready var speaker: OptionButton = $"Slot-1/SpeakerContainer/Speaker"

var options: Array[DialogueOption]:
	get:
		var opts: Array[DialogueOption] = []
		opts.assign(get_children().slice(1))
		return opts

var base_color: Color = Color.WHITE

func _ready() -> void:
	type = "dialogue"
	
	for opt: DialogueOption in options:
		if !opt.text_changed.is_connected(_on_option_text_changed):
			opt.text_changed.connect(_on_option_text_changed)
		if !opt.focus_exited.is_connected(_on_option_focus_exited):
			opt.focus_exited.connect(_on_option_focus_exited)

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
	add_empty_option()

func update_slots():
	await get_tree().process_frame
	if options.size() == 1:
		set_slot(options[0].get_index(), 
			false, 0, base_color, 
			true, 0, base_color)
		return
	
	for option: DialogueOption in options:
		var enable_right_port : bool = !option.text.is_empty()
		set_slot(option.get_index(), 
			false, 0, base_color, 
			enable_right_port, 0, base_color)

func _on_speaker_pressed() -> void:
	var path:= "res://game/characters/"
	assert(DirAccess.dir_exists_absolute(path), "No characters created!")
	
	speaker.clear()
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			speaker.add_item(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

func _on_speaker_item_selected(index: int) -> void:

	
	pass



