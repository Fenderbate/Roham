extends Particles2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	#$Sound.stream = get_parent().explosions[randi() % get_parent().explosions.size()]
	$Sound.play()
	$AnimationPlayer.play("fade")
	emitting = true
	


func _on_Sound_finished():
	queue_free()
