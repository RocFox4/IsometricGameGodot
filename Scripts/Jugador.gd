extends CharacterBody2D

var velocitat = 200
var viu = true
var xocat = false
var dash_direction = Vector2.ZERO
var dashing = false
var last_direction = Vector2.ZERO
var espai_premut = false  # Variable per controlar si l'espai està premut o no

func _ready():
	Global.SpawnPosition = Vector2(2632, 1520)
	position = Global.SpawnPosition
	$Dash.hide()
	$AnimatedSprite2D.show()
func _physics_process(delta):
	print(position)
	if Global.vides == 0:
		$Dash.hide()
		$AnimatedSprite2D.hide()
		await get_tree().create_timer(3.2).timeout
		get_node("/root/Global").g_canvi_escena("menú")
	if Global.enemicsVius == 0:
		$Dash.hide()
		$AnimatedSprite2D.hide()
		await get_tree().create_timer(3.2).timeout
		get_node("/root/Global").g_canvi_escena("menú")
	if viu:
		var direcció = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		# Capturar l'última direcció pitjada
		if direcció != Vector2.ZERO:
			last_direction = direcció.normalized()

		if dashing:
			# Si està en mode dash, no permetem controlar el personatge
			self.velocity = Vector2(dash_direction.x, dash_direction.y * 0.5) * velocitat
			move_and_slide()

			# Verificar col·lisions
			if is_on_wall() or is_on_ceiling() or is_on_floor():
				dashing = false
				velocitat = 200  # Tornar a la velocitat normal
			return
			
		if Input.is_action_just_pressed("ui_accept"):
			dashing = true
			dash_direction = last_direction
			if dash_direction == Vector2.UP or dash_direction == Vector2.DOWN:
				velocitat = 1000  # Ajusta la velocitat de dash arriba y abajo
			else:
				velocitat = 800  # Ajusta la velocitat de dash a los lados

		update_animation(direcció)

		if direcció and not dashing:
			direcció = Vector2(direcció.x, direcció.y * 0.5)
			self.velocity = direcció.normalized() * velocitat
		else:
			self.velocity = Vector2.ZERO

		move_and_slide()
	else:
		$AnimatedSprite2D.play("Trencat")

	
func update_animation(direcció):
	if !dashing:
		$Dash.hide()
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
			$AnimatedSprite2D.play("DiagonalE")
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
			$AnimatedSprite2D.play("DiagonalD")
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
			$AnimatedSprite2D.play("DiagonalEnrereD")
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
			$AnimatedSprite2D.play("DiagonalEnrereE")
		elif Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play("Endavant")
		elif Input.is_action_pressed("ui_down"):
			$AnimatedSprite2D.play("Enrere")
		elif Input.is_action_pressed("ui_right"):
			$AnimatedSprite2D.play("CostatD")
		elif Input.is_action_pressed("ui_left"):
			$AnimatedSprite2D.play("CostatE")
		elif not Input.is_anything_pressed():
			$AnimatedSprite2D.play("Quiet")
	else:
		$Dash.show()
		if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
			$AnimatedSprite2D.play("DiagonalE")
			$Dash.play("DashUL")
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
			$AnimatedSprite2D.play("DiagonalD")
			$Dash.play("DashUR")
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
			$AnimatedSprite2D.play("DiagonalEnrereD")
			$Dash.play("DashDR")
		elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
			$AnimatedSprite2D.play("DiagonalEnrereE")
			$Dash.play("DashDL")
		elif Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play("Endavant")
			$Dash.play("DashU")
		elif Input.is_action_pressed("ui_down"):
			$AnimatedSprite2D.play("Enrere")
			$Dash.play("DashD")
		elif Input.is_action_pressed("ui_right"):
			$AnimatedSprite2D.play("CostatDRàpid")
			$Dash.play("DashDreta")
		elif Input.is_action_pressed("ui_left"):
			$AnimatedSprite2D.play("CostatERàpid")
			$Dash.play("DashEsquerra")
		elif not Input.is_anything_pressed():
			$AnimatedSprite2D.play("Quiet")

func mort():
	Global.vides -=1
	velocitat = 200
	viu = false
	dashing = false
	await get_tree().create_timer(0.6).timeout
	viu = true
	position = Global.SpawnPosition
	print(position)




func _input(event):
	if event.is_action_pressed("ui_accept"):
		espai_premut = true
	elif event.is_action_released("ui_accept"):
		espai_premut = false
