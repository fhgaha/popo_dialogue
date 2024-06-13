@tool
extends "res://addons/popochiu/engine/interfaces/i_room.gd"

# classes ----
const PRStart := preload("res://game/rooms/start/room_start.gd")
# ---- classes

# nodes ----
var Start: PRStart : get = get_Start
# ---- nodes

# functions ----
func get_Start() -> PRStart: return super.get_runtime_room("Start")
# ---- functions

