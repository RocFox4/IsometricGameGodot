extends CharacterBody2D

# Declaració de variables
var dirX = 0
var dirY = 0
const SPEED = 200
const JUMP_ATTACK_SPEED = 400
var perseguir_jugador = false   
var jugador = null
var viu = true
var vides = 3
var pos_inicial = Vector2()
var jump_attack_direction = Vector2()
var atacant = false
var retreating = false
var retreat_distance = 50.0
var retreat_travelled = 0.0

# Variables per al canvi de direcció
var move_in_x = true
var distance_travelled = 0.0
var change_direction_distance = 100.0  # Distància per canviar de direcció
var proximity_threshold = 10.0  # Llindar de proximitat per canviar de direcció

func _ready():
	vides = 3
	pos_inicial = position
	Global.enemicsVius +=1
func _physics_process(_delta):
	if vides <= 0:
		await get_tree().create_timer(0.1).timeout
		queue_free()
	if jugador != null:
		# Calcular la direcció cap al jugador
		dirX = jugador.position.x - position.x
		dirY = jugador.position.y - position.y
		if atacant:
			# Si està atacant, moure cap a la direcció de l'atac
			velocity = jump_attack_direction * JUMP_ATTACK_SPEED
			
		# Verificar si hi ha una col·lisió basada en canvis de velocitat
		elif retreating:
			# Si està retrocedint, moure enrere
			velocity.x = -sign(dirX) * SPEED
			velocity.y = 0
			retreat_travelled += abs(velocity.x) * _delta
			
			if retreat_travelled >= retreat_distance:
				retreating = false
				atacant = true
				retreat_travelled = 0.0
				# Configurar la direcció de l'atac de salt
				jump_attack_direction = Vector2(sign(dirX), 0)
				if jump_attack_direction.x > 0:
					$AnimatedSprite2D.play("SaltDreta")
				else:
					$AnimatedSprite2D.play("SaltEsquerra")
		elif perseguir_jugador:
			# Decidir sobre el moviment en la direcció x o y
			if move_in_x:
				# Moure en la direcció x
				velocity.x = sign(dirX) * SPEED
				velocity.y = 0
				distance_travelled += abs(velocity.x) * _delta
				# Verificar si prou a prop per canviar de direcció
				if abs(dirX) < proximity_threshold:
					move_in_x = false
					distance_travelled = 0.0
			else:
				# Moure en la direcció y
				velocity.x = 0
				velocity.y = sign(dirY) * SPEED
				distance_travelled += abs(velocity.y) * _delta
				# Verificar si prou a prop per canviar de direcció
				if abs(dirY) < proximity_threshold:
					move_in_x = true
					distance_travelled = 0.0
			
			# Canviar de direcció després d'una certa distància
			if distance_travelled >= change_direction_distance:
				move_in_x = not move_in_x
				distance_travelled = 0.0
			
			# Reproduir l'animació apropiada
			if velocity.y != 0:
				$AnimatedSprite2D.play("Recte")
			elif velocity.x > 0:
				$AnimatedSprite2D.play("Dreta")
			else:
				$AnimatedSprite2D.play("Esquerra")

		# Moure el personatge
		move_and_slide()

		# Actualitzar la velocitat anterior

func _on_area_detecció_body_entered(body):
	if body.name == "Jugador":
		jugador = body
		perseguir_jugador = true

func _on_area_detecció_body_exited(body):
	if body.name == "Jugador":
		_reset_state()

func _on_hit_box_body_entered(body):
	if body.name == "Jugador":
		if abs(body.velocity.x) < 210 and abs(body.velocity.y) < 210:
			if atacant:
				body.mort()
				position = pos_inicial
				_reset_state()
		else:
			$AnimatedSprite2D.play("Mal")
			print("vides -1")
			vides -= 1
			print(vides)
			atacant = false
			retreating = true

func _on_hit_box_body_exited(body):
	if body.name == "Jugador":
		$AnimatedSprite2D.play("Buscant")
		jugador = body
		perseguir_jugador = true

func _on_area_atacant_body_entered(body):
	if body.name == "Jugador":
		# Aturar la persecució i començar a retrocedir
		perseguir_jugador = false
		retreating = true

func _on_area_atacant_body_exited(body):
	if body.name == "Jugador":
		# Tornar al comportament normal
		perseguir_jugador = true
		retreating = false
		atacant = false

func _reset_state():
	# Restablir tots els estats als seus valors inicials
	$AnimatedSprite2D.play("Buscant")
	jugador = null
	perseguir_jugador = false
	retreating = false
	atacant = false
