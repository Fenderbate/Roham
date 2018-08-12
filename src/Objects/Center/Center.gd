extends Node2D

var target = null

var distance = 0

var scalebase = 5

var shrink_scale = 7

export var shrink = true

var grow = false

var was_laser = false

var no_shrinkstop = false

var process = true setget process

func process(value):
	
	$StopTimer.stop()
	$PickupTimer.stop()
	$SpawnTimer.stop()
	$GrowTimer.stop()

func _ready():
	
	target = get_parent().get_node("Player")
	
#	distance calculation
#	print("built in: ",round(global_position.distance_to(target.global_position)))
#	var dist = sqrt( pow(abs(target.global_position.x - global_position.x),2) + pow(abs(target.global_position.y - global_position.y) , 2) )
#	print("calculated: ",round(dist))
	
	$PickupTimer.start()
	

func _physics_process(delta):
	
	update()
	
	if shrink:
		
		if !grow:
			if scalebase > 2:
				scalebase -= delta / shrink_scale
			else:
				scalebase = 2
		
		#max distance = Vector2(1,1).normalized() * scalebase * 70
			
	
	if grow:
			if scalebase < 5:
				scalebase += delta / 2.5
			else:
				scalebase = 5
	
	distance = scalebase * 50
	
	$Walls/Poly.scale = Vector2(scalebase,scalebase)
	

func _draw():
	
	var arr = $Walls/Poly.polygon
	
	arr.remove(21)
	arr.remove(20)
	arr.remove(19)
	arr.remove(18)
	arr.remove(17)
	
	for x in arr.size():
		arr[x] = arr[x] * $Walls/Poly.scale
	
	draw_polyline(arr,Color(1,1,1,1),5)
	
	#draw_line(Vector2(0,0),Vector2(1,1).normalized()*distance,Color(1,1,1,1),5)

func stop_shrink():
	shrink = false
	$StopTimer.start()

func give_pos_in():
	
	randomize()
	
	var ret = global_position + Vector2(rand_range(-distance,distance),rand_range(-distance,distance))
	if global_position.distance_to(ret) <= distance:
		return ret
	else:
		return give_pos_in()
	
func give_pos_out():
	
	randomize()
	
	var ret = global_position + Vector2(rand_range(-360,360),rand_range(-360,360))
	if global_position.distance_to(ret) > distance + 30:
		return ret
	else:
		return give_pos_out()

func give_pos_offscreen():
	
	randomize()
	
	var ret = global_position + Vector2(rand_range(-600,600),rand_range(-600,600))
	if abs(Vector2(360,360).distance_to(ret)) >= 530:
		return ret
	else:
		return give_pos_offscreen()

func grow():
	grow = true
	$GrowTimer.start()

func _on_StopTimer_timeout():
	shrink = true


func _on_PickupTimer_timeout():
	randomize()
	
	var r = randi() % 6
	
	var p = 0
	
	match r:
		0:
			if !no_shrinkstop:
				p = get_parent().shrinkstop.instance()
		1:
			p = get_parent().hppickup.instance()
		2:
			#p = get_parent().shrinkstop.instance()
			pass
		3:
			#p = get_parent().hppickup.instance()
			pass
		4:
			if !no_shrinkstop:
				p = get_parent().shrinkstop.instance()
		5:
			p = get_parent().hppickup.instance()
	
	if typeof(p) != TYPE_INT:
	
		p.global_position = give_pos_in()
		
		get_parent().add_child(p)
		
	$PickupTimer.start()


func _on_SpawnTimer_timeout():
	
	randomize()
	
	var r = randi() % 6
	
	var p = 0
	
	match r:
		0:
			p = get_parent().meleenemy.instance()
			was_laser = false
		1:
			p = get_parent().rangedenemy.instance()
			was_laser = false
		2:
			if !was_laser and get_parent().combo >= 10:
				p = get_parent().laserenemy.instance()
				was_laser = true
			_on_SpawnTimer_timeout()
		3:
			p = get_parent().rangedenemy.instance()
			was_laser = false
		4:
			p = get_parent().meleenemy.instance()
			was_laser = false
		5:
			if !was_laser and get_parent().combo >= 10:
				p = get_parent().laserenemy.instance()
				was_laser = true
			_on_SpawnTimer_timeout()
	
	if typeof(p) != TYPE_INT:
	
		p.global_position = give_pos_offscreen()
		
		get_parent().add_child(p)
		
		if $SpawnTimer.wait_time > 1.25:
			$SpawnTimer.wait_time -= 0.15
		else:
			$SpawnTimer.wait_time = 1.25
	$SpawnTimer.start()


func _on_GrowTimer_timeout():
	grow = false
