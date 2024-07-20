@tool
extends "res://addons/popochiu/engine/interfaces/i_dialog.gd"

# classes ----
const PDFirst := preload("res://game/dialogs/first/dialog_first.gd")
const PDSecond := preload("res://game/dialogs/second/dialog_second.gd")
const PDThird := preload("res://game/dialogs/third/dialog_third.gd")
# ---- classes

# nodes ----
var First: PDFirst : get = get_First
var Second: PDSecond : get = get_Second
var Third: PDThird : get = get_Third
# ---- nodes

# functions ----
func get_First() -> PDFirst: return get_instance("First")
func get_Second() -> PDSecond: return get_instance("Second")
func get_Third() -> PDThird: return get_instance("Third")
# ---- functions

