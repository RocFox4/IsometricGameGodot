extends Area2D



var utilitzat = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	utilitzat = false

func _on_body_entered(body):
	if body.name == "Jugador":
		print("Jugador entered")
		Global.SpawnPosition = position
		print(Global.SpawnPosition)
		if !utilitzat:
			Global.vides = 3
			utilitzat= true
