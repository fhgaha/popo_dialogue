@tool
class_name PopoGraphNode extends GraphNode

enum Type{ start, dialogue }

static func type_as_string(val: Type):
	return Type.find_key(val)

var type: Type
var offset: Vector2 = Vector2.ZERO
var data:= {}
