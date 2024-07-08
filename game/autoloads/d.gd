@tool
extends "res://addons/popochiu/engine/interfaces/i_dialog.gd"

# classes ----
const PDFirst := preload("res://game/dialogs/first/dialog_first.gd")
# ---- classes

# nodes ----
var First: PDFirst : get = get_First
# ---- nodes

# functions ----
func get_First() -> PDFirst: return E.get_dialog("First")
# ---- functions

