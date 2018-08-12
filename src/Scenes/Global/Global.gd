extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _input(event):
	if event is InputEventKey and event.pressed and !event.is_echo():
		if event.scancode == KEY_M:
			AudioServer.set_bus_mute(
					AudioServer.get_bus_index("Music"),
					!AudioServer.is_bus_mute(
							AudioServer.get_bus_index("Music")
					)
			)
			
			if AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")):
				$MusicAnim.play("music_off")
			else:
				$MusicAnim.play("music_on")
			
		elif event.scancode == KEY_N:
			AudioServer.set_bus_mute(
					AudioServer.get_bus_index("Sound"),
					!AudioServer.is_bus_mute(
							AudioServer.get_bus_index("Sound")
					)
			)
			
			if AudioServer.is_bus_mute(AudioServer.get_bus_index("Sound")):
				$SoundAnim.play("sound_off")
			else:
				$SoundAnim.play("sound_on")
		
		elif event.scancode == KEY_ESCAPE:
			if get_tree().root.has_node("World"):
				if !get_tree().paused:
					get_tree().paused = true
					get_tree().root.get_node("World/PausedPanel").show()
				else:
					get_tree().change_scene("res://src/Scenes/Menu/Menu.tscn")
					get_tree().paused = false
		
		elif event.scancode == KEY_SPACE:
			if get_tree().root.has_node("World") and get_tree().paused and get_tree().root.get_node("World/Player").health > 0:
				get_tree().paused = false
				get_tree().root.get_node("World/PausedPanel").hide()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
