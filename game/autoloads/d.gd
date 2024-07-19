@tool
extends "res://addons/popochiu/engine/interfaces/i_dialog.gd"

# classes ----
const PDFirst := preload("res://game/dialogs/first/dialog_first.gd")
const PDSecond := preload("res://game/dialogs/second/dialog_second.gd")
# ---- classes

# nodes ----
var First: PDFirst : get = get_First
var Second: PDSecond : get = get_Second
# ---- nodes

# functions ----
func get_First() -> PDFirst: return get_instance("First")
func get_Second() -> PDSecond: return get_instance("Second")
# ---- functions

