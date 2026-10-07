extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Vida1.show()
	$Vida2.show()
	$Vida3.show()
	$M1.hide()
	$M2.hide()
	$M3.hide()
	$Label.hide()
func _process(delta):
	if Global.vides == 3:
		$Vida1.show()
		$Vida2.show()
		$Vida3.show()
		$M1.hide()
		$M2.hide()
		$M3.hide()
	if Global.vides == 2:
		$Vida1.hide()
		$M1.show()
		await get_tree().create_timer(0.2).timeout
		$M1.hide()
	elif Global.vides == 1:
		$Vida2.hide()
		$M2.show()
		await get_tree().create_timer(0.2).timeout
		$M2.hide()
	elif Global.vides == 0:
		$Vida3.hide()
		$M3.show()
		await get_tree().create_timer(0.2).timeout
		$M3.hide()
		$Label.show()
	if Global.enemicsVius ==0:
		$Label.show()
		$Label.set_text("HAS GUANYAT
		ENORABONA! :)")	
		
