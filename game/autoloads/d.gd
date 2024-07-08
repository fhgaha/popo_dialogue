@tool
extends "res://addons/popochiu/engine/interfaces/i_dialog.gd"

# classes ----
const PDAaa := preload("res://game/dialogs/aaa/dialog_aaa.gd")
const PDBbb := preload("res://game/dialogs/bbb/dialog_bbb.gd")
# ---- classes

# nodes ----
var Aaa: PDAaa : get = get_Aaa
var Bbb: PDBbb : get = get_Bbb
# ---- nodes

# functions ----
func get_Aaa() -> PDAaa: return get_instance("Aaa")
func get_Bbb() -> PDBbb: return get_instance("Bbb")
# ---- functions

