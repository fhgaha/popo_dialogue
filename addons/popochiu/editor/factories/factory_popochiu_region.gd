class_name PopochiuRegionFactory
extends "res://addons/popochiu/editor/factories/factory_base_popochiu_room_obj.gd"

#region Godot ######################################################################################
func _init() -> void:
	_type = PopochiuResources.Types.REGION
	_type_label = "region"
	_obj_room_group = "Regions"
	_path_template = "/regions/%s/region_%s"


#endregion

#region Public #####################################################################################
func create(obj_name: String, room: PopochiuRoom) -> int:
	# If everything goes well, this won't change.
	var result_code := ResultCodes.SUCCESS

	_setup_room(room)
	_setup_name(obj_name)

	# Create the folder
	result_code = _create_obj_folder()
	if result_code != ResultCodes.SUCCESS: return result_code
	
	# Create the script
	result_code = _copy_script_template()
	if result_code != ResultCodes.SUCCESS: return result_code

	# ---- LOCAL CODE ------------------------------------------------------------------------------
	# Create the instance
	var new_obj: PopochiuRegion = _load_obj_base_scene()
	
	new_obj.set_script(ResourceLoader.load(_path_script))

	new_obj.name = _pascal_name
	new_obj.script_name = _pascal_name
	new_obj.description = _snake_name.capitalize()

	# Save the scene (.tscn) and put it into _scene class property
	result_code = _save_obj_scene(new_obj)
	if result_code != ResultCodes.SUCCESS: return result_code

	# Create a collision polygon as a child in the room scene
	var collision := CollisionPolygon2D.new()
	collision.name = "InteractionPolygon"
	collision.modulate = Color.CYAN
	_add_visible_child(collision)
	# ---- END OF LOCAL CODE -----------------------------------------------------------------------

	# Add the object to its room
	_add_resource_to_room()

	return result_code


#endregion
