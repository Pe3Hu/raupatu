extends Node3D


func _ready():
	#Global.obj.leinwand = Classes_1.Leinwand.new()
	Global.obj.bienenstock = Classes_3.Bienenstock.new()
	Global.obj.spielautomat = Classes_4.Spielautomat.new()
#	datas.sort_custom(Classes_0.Sorter, "sort_ascending")



func _input(event):
	if event is InputEventMouseButton:
		Global.mouse_pressed = !Global.mouse_pressed
	else:
		Global.mouse_pressed = !Global.mouse_pressed
	
	if event is InputEventKey:
		match event.keycode:
			KEY_A:
				Global.node.camera.rotation.y += 0.01
				Global.node.game.get_node("Spielautomat").rotation.y += 0.01
				#Global.obj.spielautomat.recalc_positions()
				var camera_direction = -Global.node.camera.transform.basis.z.normalized()
				print(camera_direction)
			KEY_D:
				Global.node.camera.rotation.y -= 0.01
				Global.node.game.get_node("Spielautomat").rotation.y -= 0.01
				#Global.obj.spielautomat.recalc_positions()
	


func _process(delta):
	$FPS.text = str(Engine.get_frames_per_second())
