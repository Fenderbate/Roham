extends Particles2D


func _ready():
	emitting = true
	$Sound.play()


func _on_Sound_finished():
	queue_free()
