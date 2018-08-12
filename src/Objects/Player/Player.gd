extends KinematicBody2D

var dir = Vector2(0,0)
var attackdir = Vector2(0,-1)
var adtest = Vector2(0,0)
var speed = 250

var dash_distance = 250
var can_dash = true
var fixed = false

var health = 3
var vincible = true

var enemy_hit = false

func _ready():
	
	$Torso.rotation = deg2rad(-90)

func _input(event):
	if event is InputEventMouseButton:
#		if event.button_index == 1 and event.pressed and $Torso/Weapon/WeaponTimer.time_left == 0:
#			$Torso/Weapon.monitoring = true
#			$Torso/Weapon/Sprite.show()
#			$Torso/Weapon/WeaponTimer.start()
			pass
	elif event is InputEventKey and event.pressed and !event.is_echo():
		if event.scancode == KEY_SPACE and can_dash and attackdir != Vector2(0,0) and $DashCDTimer.time_left == 0 and (!get_tree().paused or get_parent().get_node("LostPanel").visible):
			$Torso/Weapon.monitoring = true
			vincible = false
			fixed = true
			enemy_hit = false
			$DashTimer.start()
			$Tween.interpolate_property(self,"position", position, position + attackdir*dash_distance, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT)
			$Tween.start()
			$DashCDTimer.start()
			$Dash.play()

func _physics_process(delta):
	
#	for i in get_slide_count():
#		if get_slide_collision(i):
#			$Tween.stop(self,"position")
#			$Torso/Weapon.monitoring = false
	
	if get_slide_count() > 0:
		if get_slide_collision(0):
#				$Tween.stop(self,"position")
#				$Torso/Weapon.monitoring = false
#				vincible = true
				if $DashCDTimer.time_left > 0 and !enemy_hit:
					$Torso/Weapon/Sprite.hide()
	
	dir.x = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("A"))
	
	dir.y = int(Input.is_action_pressed("S")) - int(Input.is_action_pressed("W"))
	
	adtest.x = int(Input.is_action_pressed("L")) - int(Input.is_action_pressed("J"))
	
	adtest.y = int(Input.is_action_pressed("K")) - int(Input.is_action_pressed("I"))
	
	dir = dir.normalized()
	
	adtest = Vector2(stepify(adtest.normalized().x,0.1),stepify(adtest.normalized().y,0.1))
	
	var motion = dir * speed
	
	motion = move_and_slide(motion)
	
	#$Torso.look_at(get_global_mouse_position())
	
	
	
	if adtest != Vector2(0,0):
		attackdir = adtest
		rotate_torso()

func rotate_torso():
	
	var rot = 0
	
	$Torso/Shield/Sprite.show()
	if $DashCDTimer.time_left == 0:
		$Torso/Weapon/Sprite.show()
	
	if !fixed:
		match attackdir:
			Vector2(0,-1):
				rot = 0
			Vector2(0.7,-0.7):
				rot = 45
			Vector2(1,0):
				rot = 90
			Vector2(0.7,0.7):
				rot = 135
			Vector2(0,1):
				rot = 180
			Vector2(-0.7,0.7):
				rot = 225
			Vector2(-1,0):
				rot = 270
			Vector2(-0.7,-0.7):
				rot = 315
		
		$Torso.rotation = deg2rad(rot - 90)
		adtest = attackdir

func hurt():
	if vincible:
		$Hurt.play()
		vincible = false
		health -= 1
		$Torso/Healthbar.value = health
		#$Label.text = str(health)
		$InvincPlayer.play("Invincible")
		if health < 0:
			get_parent().get_node("Center").process = false
			get_parent().get_node("LostPanel/You lost").text += str(get_parent().score,"\nBest combo: ",get_parent().max_combo)
			get_parent().get_node("LostPanel").show()
			#get_tree().paused = true
			health = -1

func heal():
	health = health + 1 if health < 3 else 3
	
	$Torso/Healthbar.value = health

func vincible():
	vincible = true

func _on_Weapon_area_entered(area):
	if area.is_in_group("Bullet"):
		area.queue_free()
		return
	elif area.is_in_group("Menu"):
		get_parent().menu(area.name)
		$DashCDTimer.stop()
		$AnimationPlayer.play("attackup")
		return
	elif area.is_in_group("Panel"):
		get_parent().get_node("LostPanel").menu(area.name)
		$DashCDTimer.stop()
		$AnimationPlayer.play("attackup")
		return
	area.hurt()
	enemy_hit = true
	$DashCDTimer.stop()
	print("I REACHED THIS POINT!")
	$AnimationPlayer.play("attackup")

func _on_Tween_tween_completed(object, key):
	$Torso/Weapon.monitoring = false
	if !enemy_hit:
		$Torso/Weapon/Sprite.hide()
	vincible = true
	fixed = false
	if !enemy_hit:
		get_parent().combo_end()


func _on_Margin_body_entered(body):
	if $Tween.is_active():
		$Tween.stop(self,"position")
		$Torso/Weapon.monitoring = false
		if !enemy_hit:
			$Torso/Weapon/Sprite.hide()
		vincible = true
		fixed = false
	
	can_dash = false


func _on_Margin_body_exited(body):
	can_dash = true


func _on_DashTimer_timeout():
	$Tween.stop(self,"position")
	$Torso/Weapon.monitoring = false
	vincible = true
	fixed = false
	if !enemy_hit:
		$Torso/Weapon/Sprite.hide()
		get_parent().combo_end()


func _on_DashCDTimer_timeout():
	$AnimationPlayer.play("attackup")
