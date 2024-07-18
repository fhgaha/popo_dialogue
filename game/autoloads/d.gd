@tool
extends "res://addons/popochiu/engine/interfaces/i_dialog.gd"

# classes ----
const PDFirst := preload("res://game/dialogs/first/dialog_first.gd")
const PDForth := preload("res://game/dialogs/forth/dialog_forth.gd")
# ---- classes

# nodes ----
var First: PDFirst : get = get_First
var Forth: PDForth : get = get_Forth
# ---- nodes

# functions ----
func get_First() -> PDFirst: return get_instance("First")
func get_Forth() -> PDForth: return get_instance("Forth")
# ---- functions

