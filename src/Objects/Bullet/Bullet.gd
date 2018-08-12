extends Area2D

var dir = Vector2(0,0)

var speed = 300

func _ready():
	
	$Sound.play()
	
	pass

func _physics_process(delta):
	
	global_position += (dir * speed) * delta
	
	$Sprite.rotation += delta * 3


func _on_Bullet_body_entered(body):
	body.hurt()
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
