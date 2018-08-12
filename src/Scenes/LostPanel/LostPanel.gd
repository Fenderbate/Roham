extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func menu(optionname):
	match optionname:
		"ExitArea":
			_on_Exit_button_down()
		"RetryArea":
			_on_Retry_button_down()
		_:
			print("OOPS!   ", optionname)

func _on_Exit_button_down():
	get_tree().change_scene("res://src/Scenes/Menu/Menu.tscn")
	get_tree().paused = false


func _on_LostPanel_visibility_changed():
	#get_parent().get_node("Player").hide()
	get_parent().get_node("Center").hide()
	get_parent().get_node("Score").hide()
	get_parent().get_node("Center/Walls/Poly").scale = Vector2(5,5)
	$RetryArea/CollisionShape2D.disabled = false
	$ExitArea/CollisionShape2D.disabled = false
	
	for child in get_tree().get_nodes_in_group("Enemy"):
		child.queue_free()


func _on_Retry_button_down():
	get_tree().reload_current_scene()
