extends Area2D

var target = null

var speed = 250

var can_shoot = true

var shooting = false

func _ready():
	
	target = get_parent().get_node("Player")
	

func _physics_process(delta):
	
	speed = global_position.distance_to(target.global_position) / 1.5
	
	if global_position.distance_to(target.global_position) > 180:
		global_position += ((target.global_position - global_position).normalized() * speed) * delta
	else:
		if $ShootTimer.time_left == 0 and ($ShootTimer.is_stopped()or $ShootTimer.paused):
			$ShootTimer.start()

func hurt(par = -1):
	if par == -1:
		get_parent().score(10)
	$Sprite.hide()
	$CollisionShape2D.disabled = true
	can_shoot = false
	get_parent().explode(global_position,"76428a",$Sprite.texture,3)

func shoot():
	
	var b = get_parent().bullet.instance()
	
	b.global_position = $BulletPivot.global_position
	
	b.dir = (target.global_position - global_position).normalized()
	
	#b.get_node("Sprite").look_at(target.global_position)
	
	get_parent().add_child(b)
	
	$Sprite.frame = 2
	shooting = true
	$AnimTimer.start()
	
func _on_RangedEnemy_body_entered(body):
	if $DamageTimer.time_left == 0:
		body.hurt()
		$DamageTimer.start()


func _on_RangedEnemy_body_exited(body):
	$DamageTimer.stop()


func _on_DamageTimer_timeout():
	if target != null:
		target.hurt()


func _on_ShootTimer_timeout():
	if global_position.distance_to(target.global_position) < 250 and can_shoot:
		shoot()
		$ShootTimer.start()


func _on_AnimTimer_timeout():
	if !shooting:
		match $Sprite.frame:
			0:
				$Sprite.frame = 1
			1:
				$Sprite.frame = 0
	else:
		shooting = false
		$Sprite.frame = 0
