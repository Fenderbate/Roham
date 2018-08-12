extends Area2D

var target = null

var speed = 200

var pause = false

func _ready():
	
	target = get_parent().get_node("Player")
	

func _physics_process(delta):
	
	if !pause:
		if global_position.distance_to(target.global_position) > 20:
			global_position += ((target.global_position - global_position).normalized() * speed) * delta

func hurt(par = -1):
	if par == -1:
		get_parent().score(5)
	$Sprite.hide()
	$CollisionShape2D.disabled = true
	get_parent().explode(global_position,"ac3232",$Sprite.texture,2)
	

func _on_MeleEnemy_body_entered(body):
	if $DamageTimer.time_left == 0:
		body.hurt()
		$DamageTimer.start()
		$PauseTimer.start()
		pause = true


func _on_MeleEnemy_body_exited(body):
	$DamageTimer.stop()


func _on_DamageTimer_timeout():
	if target != null:
		target.hurt()


func _on_PauseTimer_timeout():
	pause = false


func _on_AnimTimer_timeout():
	match $Sprite.frame:
		0:
			$Sprite.frame = 1
		1:
			$Sprite.frame = 0
