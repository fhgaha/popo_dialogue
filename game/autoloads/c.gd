@tool
extends "res://addons/popochiu/engine/interfaces/i_character.gd"

# classes ----
const PCMain := preload("res://game/characters/main/character_main.gd")
const PCNpc := preload("res://game/characters/npc/character_npc.gd")
# ---- classes

# nodes ----
var Main: PCMain : get = get_Main
var Npc: PCNpc : get = get_Npc
# ---- nodes

# functions ----
func get_Main() -> PCMain: return super.get_runtime_character("Main")
func get_Npc() -> PCNpc: return super.get_runtime_character("Npc")
# ---- functions

