extends Node



#Символ
class Symbol:
	var obj = {}


	func _init(input_) -> void:
		obj.rolle = input_.rolle


#Плитка
class Kacheln:
	var num = {}
	var vec = {}
	var obj = {}
	var mesh = {}


	func _init(input_) -> void:
		num.order = {}
		num.order.current = input_.order
		num.order.start = 0
		num.order.end = Global.num.pielautomat.height+2
		obj.rolle = input_.rolle
		obj.spielautomat = obj.rolle.obj.spielautomat
		obj.symbol = null
		vec.start = Global.vec.center.spielautomat
		#obj.rolle.num.col
		vec.shift = Vector3(1,0,0)
		init_mesh()


	func init_mesh() -> void:
		mesh.plane = MeshInstance3D.new()
		mesh.plane.mesh = PlaneMesh.new()
		mesh.plane.mesh.size = Vector2(1,1)
		mesh.plane.position = Global.node.camera.position
		mesh.plane.mesh.center_offset = Global.vec.shift.spielautomat
		mesh.plane.mesh.center_offset.y += num.order.current
		mesh.plane.mesh.center_offset.x += obj.rolle.num.col
		
		var material = StandardMaterial3D.new()
		material.vertex_color_use_as_albedo = true
		mesh.plane.mesh.surface_set_material(0, material)  
		var color = Color.SLATE_GRAY
		
		mesh.plane.mesh.material.albedo_color = color
		obj.spielautomat.scene.myself.add_child(mesh.plane)
		mesh.plane.mesh.set_orientation(2)
		mesh.plane.set_cast_shadows_setting(0)
		mesh.plane.rotation = Global.node.camera.rotation


#Рулон
class Rolle:
	var num = {}
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		num.col = input_.col
		obj.spielautomat = input_.spielautomat
		init_kachelns()


	func init_kachelns() -> void:
		arr.kacheln = []
		
		for _i in Global.num.pielautomat.height+2:
			var input = {}
			input.order = _i
			input.rolle = self
			var kacheln = Classes_4.Kacheln.new(input)
			arr.kacheln.append(kacheln)


#Слот-машина
class Spielautomat:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init() -> void:
		init_scene()
		init_rolles()
		init_symbols()


	func init_scene() -> void:
		scene.myself = Global.scene.spielautomat.instantiate()
		Global.node.game.add_child(scene.myself)


	func init_rolles() -> void:
		arr.rolle = []
		
		for _i in Global.num.pielautomat.width:
			var input = {}
			input.col = _i
			input.spielautomat = self
			var rolle = Classes_4.Rolle.new(input)
			arr.rolle.append(rolle)


	func init_symbols() -> void:
		var input = {}
		input.height = Global.num.saal.height
		input.width = Global.num.saal.width
		input.depth = Global.num.saal.depth
		input.bienenstock = self
		#obj.saal = Classes_4.Saal.new(input)


	func recalc_positions() -> void:
		var angle = Global.vec.angle.camera-Global.node.camera.rotation
		var vector = Vector3()+Global.vec.shift.spielautomat
		vector.rotated(Vector3(1,0,0),angle.x)
		vector.rotated(Vector3(0,1,0),angle.y)
		vector.rotated(Vector3(0,0,1),angle.z)
		print(vector,angle)
		
		
		var x_axis = Vector3(1, 0, 0)
		var y_axis = Vector3(0, 1, 0)
		var pivot_point = Global.node.camera.position
		var pivot_radius = Global.vec.shift.spielautomat
		
		
		#scene.myself.rotation = Global.node.camera.rotation
		for rolle in arr.rolle:
			for kacheln in rolle.arr.kacheln:
				kacheln.mesh.plane.rotation = Global.node.camera.rotation
				#var position = Global.node.camera.position+vector
				#kacheln.mesh.position = position
				
				#var pivot_transform = Transform3D(kacheln.mesh.transform.basis, pivot_point)
				#kacheln.mesh.transform = pivot_transform.rotated(y_axis, angle.y).translated(pivot_radius)
				

