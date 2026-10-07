extends Control


# Called when the node enters the scene tree for the first time.
func _on_sortir_pressed():
	get_tree().quit()


func _on_inici_pressed():
	get_node("/root/Global").g_canvi_escena("lvl1")


