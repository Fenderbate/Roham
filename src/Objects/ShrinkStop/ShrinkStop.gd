extends Area2D

func _physics_process(delta):
	
	$Sprite.rotation += delta * 3

func _on_ShrinkStop_body_entered(body):
	if body.is_in_group("Wall"):
		queue_free()
		return
	get_parent().get_node("Center").stop_shrink()
	get_parent().pickup(global_position,"5b6ee1",get_parent().shrinkstopsound)
	queue_free()


func _on_LifetimeTimer_timeout():
	$AnimationPlayer.play("vanish")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
