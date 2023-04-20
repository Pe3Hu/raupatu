extends Node3D


func _ready() -> void:
	#Global.obj.leinwand = Classes_1.Leinwand.new()
	Global.obj.brunnen = Classes_2.Brunnen.new()
	Global.obj.bienenstock = Classes_3.Bienenstock.new()
	Global.obj.spielautomat = Classes_4.Spielautomat.new()
	Global.obj.hexenzirkel = Classes_5.Hexenzirkel.new()
#	datas.sort_custom(func(a, b): return a.value > b.value)
	set_camera()
	next_turn()


func set_camera() -> void:
	var width = Global.num.saal.width
	var half_width = float(width)/2
	var camera = get_node("/root/Game/Camera")
	camera.position = Global.vec.position.camera[width]
	$Bienenstock/PlaneX.mesh["size"].x = width
	$Bienenstock/PlaneX.mesh["center_offset"].z = half_width
	$Bienenstock/PlaneY.mesh["size"].y = width
	$Bienenstock/PlaneY.mesh["center_offset"].z = half_width


func _input(event) -> void:
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


func next_turn() -> void:
	if Global.obj.hexenzirkel.flag.end_turn:
		Global.obj.hexenzirkel.flag.end_turn = false
		Global.obj.bienenstock.clean_ankers()
		Global.obj.spielautomat.rolles_roll()
		
		Global.obj.bienenstock.add_ankers()
		
		Global.obj.hexenzirkel.zauberers_turn()

func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
