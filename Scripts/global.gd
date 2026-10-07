extends Node

const ESC_INICI: = preload("res://Escenes/inici.tscn")
const ESC_ESCENARI_1: = preload("res://Escenes/escenari.tscn")
var vides = 3
var enemicsVius = 0
var SpawnPosition = Vector2(2632, 1520)
# Called when the node enters the scene tree for the first time.
func g_canvi_escena(escActual:String):
	if escActual == "lvl1":
		get_tree().change_scene_to_packed(ESC_ESCENARI_1)
	elif escActual== "menú":
		get_tree().change_scene_to_packed(ESC_INICI)
