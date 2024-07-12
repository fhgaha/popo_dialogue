class_name ConditionNodeData extends NodeData

@export var value1          : String
@export var operator        : String
@export var value2          : String
@export var true_next_node  : String
@export var false_next_node : String

func get_typed_value(value: String, variables: Dictionary) -> Variant:
	var found_var: Dictionary
	for key in variables:
		if key == value1:
			found_var = {
				"name" : key, 
				"type" : variables[key]["type"],
				"value": variables[key]["value"]
			}
	
	#var variable
	#
	#match found_var1["type"]:
		#TYPE_STRING:
			#variable = found_var1["value"]
		#TYPE_INT:
			#variable = found_var1["value"].to_int()
		#TYPE_FLOAT:
			#variable = found_var1["value"].to_float()
		#TYPE_BOOL:
			#variable = true if found_var1["value"].to_lower() == "true" else "false"
		#_:
					#pass
	
	return found_var["value"]
