extends Area2D

func _physics_process(delta):
	
	$Sprite.rotation += delta * 3

func _on_HPPickup_body_entered(body):
	if body.is_in_group("Wall"):
		queue_free()
		return
	body.heal()
	get_parent().pickup(global_position,"37946e",get_parent().hppickupsound)
	queue_free()
	



func _on_LifetimeTimer_timeout():
	$AnimationPlayer.play("vanish")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
