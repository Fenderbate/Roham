extends Node

var cam_pos = Vector2()

func _ready():
	
	pass
	
func _process(delta):
	
	
	update_camera_pos()
	cam_to_pos()
	
	if $CheckButton.has_focus():
		$CheckButton.release_focus()

func update_camera_pos():
	
	var new_pos = calculate_new_pos()
	if cam_pos == new_pos:
		return
	cam_pos = new_pos
	
	

func calculate_new_pos():
	
	var x = floor($Player.position.x / 720)
	var y = floor($Player.position.y / 720)
	
	return Vector2(x,y)

func combo_end():
	pass

func cam_to_pos():
	$Camera.position += ((cam_pos * 720) - $Camera.position) / 4 * get_physics_process_delta_time()

func menu(optionname):
	match optionname:
		"StartArea":
			_on_Start_button_down()
		"OptionsArea":
			_on_Options_button_down()
		"ExitArea":
			_on_Exit_button_down()
		"YesArea":
			if $Container/ExitPropmt.visible:
				get_tree().quit()
		"NoArea":
			if $Container/ExitPropmt.visible:
				$Container/ExitPropmt.hide()
				$Container/TextStuff.show()
		_:
			print("OOPS!   ", optionname)

func _on_Start_button_down():
	if !$Container/OptionPanel.visible and !$Container/ExitPropmt.visible:
		get_tree().change_scene("res://src/Scenes/World/World.tscn")


func _on_Options_button_down():
	print($Container/OptionPanel.visible,"   ",$Container/ExitPropmt.visible)
	if !$Container/OptionPanel.visible and !$Container/ExitPropmt.visible:
		$Container/OptionPanel.show()
		$Container/TextStuff.show()
		

func _on_Exit_button_down():
	if !$Container/OptionPanel.visible and !$Container/ExitPropmt.visible:
		$Container/ExitPropmt.show()
		$Container/TextStuff.hide()


func _on_Yes_button_down():
	get_tree().quit()


func _on_No_button_down():
	$Container/ExitPropmt.hide()
	$Container/TextStuff.show()


func _on_Close_button_down():
	$Container/OptionPanel.hide()


func _on_CheckButton_toggled(button_pressed):
	match button_pressed:
		true:
			$Container.show()
		false:
			$Container.hide()
		_:
			return
