extends Node

var meleenemy = preload("res://src/Objects/MeleEnemy/MeleEnemy.tscn")
var rangedenemy = preload("res://src/Objects/RangedEnemy/RangedEnemy.tscn")
var laserenemy = preload("res://src/Objects/LaserEnemy/LaserEnemy.tscn")

var bullet = preload("res://src/Objects/Bullet/Bullet.tscn")

var shrinkstop = preload("res://src/Objects/ShrinkStop/ShrinkStop.tscn")
var hppickup = preload("res://src/Objects/HPPickup/HPPickup.tscn")

var lasercharge = preload("res://src/Objects/LaserEnemy/laser_chargeup.wav")
var lasershoot = preload("res://src/Objects/LaserEnemy/laser_shot.wav")

var explosions = [
preload("res://src/Resources/explosion_1.wav"),
preload("res://src/Resources/explosion_2.wav"),
preload("res://src/Resources/explosion_3.wav")
]

var shrinkstopsound = preload("res://src/Resources/shrinkstoppickup.wav")
var hppickupsound = preload("res://src/Resources/hppickupsound.wav")

var explosion = preload("res://src/Objects/Explosion/Explosion.tscn")

var pickup = preload("res://src/Objects/Pcikup/Pickup.tscn")

var score = 0

var combo = 0

var max_combo = 0

func _ready():

	pass
	

func _physics_process(delta):
	
	$Score.text = str("Score: ",score)
	
	$ComboMeter.value = ($ComboTimer.time_left / $ComboTimer.wait_time) * 100

func score(amount):
	score += amount
	combo_up()

func combo_up():
	combo += 1
	if combo > max_combo:
		max_combo = combo
	if $ComboTimer.time_left == 0:
		$ComboTimer.start()
		$Combo.show()
	else:
		$ComboTimer.start()
	$Combo.text = str("x",combo)
	
	if combo % 5 == 0:
		$Center.grow()
	if combo % 50 == 0:
		$Center.no_shrinkstop = true
		$Center.shrink_scale = 9
		spawn_pickup(1)

func spawn_pickup(par = -1):
	
	var p = 0
	
	match par:
		-1:
			return
		0:
			p = shrinkstop.instance()
		1:
			p = hppickup.instance()
		_:
			return
	
	p.global_position = Vector2(360,360)
	
	add_child(p)

func explode(pos, color = Color(1,1,1,1),image = null,sprite_frames = 1):
	var e = explosion.instance()
	e.global_position = pos
	e.self_modulate = Color(str(color))
	e.get_node("Sprite").hframes = sprite_frames
	if image != null:
		e.get_node("Sprite").texture = image
	add_child(e)

func pickup(pos, color = Color(1,1,1,1), sound = null):
	var p = pickup.instance()
	p.position = pos
	p.self_modulate = color
	p.get_node("Sound").stream = sound
	add_child(p)

func combo_end():
	$Center.no_shrinkstop = false
	$Center.shrink_scale = 7
	combo = 0
	$Combo.hide()
	$ComboTimer.stop()
	$ComboMeter.value = 0

func _on_ScoreTimer_timeout():
	score += 1 + combo


func _on_ComboTimer_timeout():
	combo_end()
