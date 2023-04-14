extends Node3D


func _ready():
	#Global.obj.leinwand = Classes_1.Leinwand.new()
	Global.obj.brunnen = Classes_2.Brunnen.new()
	Global.obj.bienenstock = Classes_3.Bienenstock.new()
	Global.obj.spielautomat = Classes_4.Spielautomat.new()
#	datas.sort_custom(func(a, b): return a.value > b.value)


func _input(event):
	if event is InputEventMouseButton:
		Global.mouse_pressed = !Global.mouse_pressed
	else:
		Global.mouse_pressed = !Global.mouse_pressed
	
	if event is InputEventKey:
		match event.keycode:
			KEY_A:
				Global.node.camera.rotation.y += 0.04
			KEY_D:
				Global.node.camera.rotation.y -= 0.04
			KEY_W:
				Global.node.camera.rotation.x += 0.04
			KEY_S:
				Global.node.camera.rotation.x -= 0.04
			KEY_SPACE:
				if event.pressed:
					Global.obj.spielautomat.next_turn()
	


func _process(delta_):
	$FPS.text = str(Engine.get_frames_per_second())
