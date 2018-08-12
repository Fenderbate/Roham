extends Area2D

var laser = false

var origin = Vector2(0,0)

var follow_player = true

func _ready():
	
	origin = global_position
	

func _physics_process(delta):
	
	if follow_player:
		look_at(get_parent().get_node("Player").global_position)
	
	if abs(global_position.distance_to(Vector2(360,360))) > 300:
		global_position += ((Vector2(360,360) - global_position).normalized() * global_position.distance_to(Vector2(360,360))) * delta
	else:
		if !laser:
			if !$AnimationPlayer.is_playing():
				$AnimationPlayer.play("laser")
			

func laser_shot():
	laser = true
	follow_player = false

func fin():
	$Tween.interpolate_property(self,"position",position,origin,0.5,Tween.TRANS_QUART,Tween.EASE_OUT)
	$Tween.start()

func charge():
	$Sound.stream = get_parent().lasercharge
	$Sound.play()

func fire():
	$Sound.stream = get_parent().lasershoot
	$Sound.play()

func stop():
	$Sound.stop()

func hurt(par = -1):
	pass

func _on_Laser_body_entered(body):
	body.hurt()


func _on_Laser_area_entered(area):
	area.hurt(0)


func _on_Tween_tween_completed(object, key):
	queue_free()
