extends Node


#жук
class Fehler:
	var num = {}
	var word = {}
	var obj = {}
	var mesh = {}
	var scene = {}
	var color = {}


	func _init(input_) -> void:
		num.index = Global.num.index.fehler
		Global.num.index.fehler += 1
		obj.bienenstock = input_.bienenstock
		word.type = input_.type
		obj.bienenstock = input_.bienenstock
		obj.saal = obj.bienenstock.obj.saal
		obj.pfeiler = null
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.fehler.instantiate()
		scene.myself.set_label(str(num.index))
		Global.node.game.get_node("Fehlers").add_child(scene.myself)
		update_color()
		get_emlbem()


	func update_position() -> void:
		var position = obj.pfeiler.vec.grid
		position.y += obj.pfeiler.arr.fehler.find(self)*0.5
		scene.myself.set_position(position)


	func update_color() -> void:
		var type = word.type
		type = type.left(type.length() - 3)
		
		match type:
			"none":
				color.cube = Color.DIM_GRAY
			"dodge":
				color.cube = Color.DEEP_SKY_BLUE
			"armour":
				color.cube = Color.BLUE
			"resistance":
				color.cube = Color.PURPLE
			"chitin":
				color.cube = Color.ORANGE
			"flesh":
				color.cube = Color.RED
			"speed":
				color.cube = Color.GREEN
		
		scene.myself.set_color(color.cube)


	func get_emlbem() -> void:
		var type = word.type
		type = type.left(type.length() - 3)
		word.emblem = Global.get_random_element(Global.dict.emlbem.aspect[type])
		Global.dict.emlbem.aspect[type].erase(word.emblem)
		scene.myself.set_emlbem(word.emblem)
		#print(word.emblem)


	func jump(step_) -> void:
		var next_grid = Vector3()+obj.pfeiler.vec.grid
		next_grid.x += step_
		
		if next_grid.x < obj.saal.num.depth:
			var next_pfeiler = obj.saal.arr.pfeiler[next_grid.z][next_grid.x]
			next_pfeiler.add_fehler(self)


	func boom() -> void:
		print('boom')


#столб
class Pfeiler:
	var vec = {}
	var obj = {}
	var arr = {}
	var scene = {}
	var mesh = {}


	func _init(input_) -> void:
		vec.grid = Vector3(input_.width, 0, input_.depth)
		obj.saal = input_.saal
		arr.fehler = []
		init_mesh()


	func init_mesh() -> void:
		mesh.plane = MeshInstance3D.new()
		mesh.plane.mesh = PlaneMesh.new()
		mesh.plane.mesh.size = Vector2(1,1)
		mesh.plane.position = vec.grid+Vector3(0.5,0,0.5)
		
		var material = StandardMaterial3D.new()
		material.vertex_color_use_as_albedo = true
		mesh.plane.mesh.surface_set_material(0, material)  
		var color = null
		var index = (int(vec.grid.x)+int(vec.grid.z))%2
		
		match index:
			0:
				color = Color.BLACK
			1:
				color = Color.WHITE
		
		mesh.plane.mesh.material.albedo_color = color
		Global.node.game.get_node("Pfeilers").add_child(mesh.plane)


	func add_fehler(fehler_) -> void:
		if fehler_.obj.pfeiler != null:
			fehler_.obj.pfeiler.remove_fehler(fehler_)
		
		if arr.fehler.size() < obj.saal.num.height:
			arr.fehler.append(fehler_)
			fehler_.obj.pfeiler = self
			fehler_.update_position()
		else:
			var x = vec.grid.x+1
			
			if x < obj.saal.num.depth:
				obj.saal.arr.pfeiler[vec.grid.z][x].add_fehler(fehler_)
			else:
				fehler_.boom()


	func remove_fehler(fehler_) -> void:
		arr.fehler.erase(fehler_)


#зал
class Saal:
	var num = {}
	var obj = {}
	var arr = {}
	var scene = {}


	func _init(input_) -> void:
		num.height = input_.height
		num.width = input_.width
		num.depth = input_.depth
		obj.bienenstock = input_.bienenstock
		init_pfeilers()


	func init_pfeilers() -> void:
		arr.pfeiler = []
		
		for _i in num.width:
			arr.pfeiler.append([])
			
			for _j in num.depth:
				var input = {}
				input.width = _j
				input.depth = _i
				input.saal = self
				arr.pfeiler[_i].append(Classes_3.Pfeiler.new(input))


#улей
class Bienenstock:
	var obj = {}
	var arr = {}
	var scene = {}


	func _init() -> void:
		init_saal()
		init_fehlers()


	func init_saal() -> void:
		var input = {}
		input.height = Global.num.saal.height
		input.width = Global.num.saal.width
		input.depth = Global.num.saal.depth
		input.bienenstock = self
		obj.saal = Classes_3.Saal.new(input)


	func init_fehlers() -> void:
		arr.fehler = []
		var types = {}
		types["none"] = 20
		types["dodge"] = 6
		types["armour"] = 5
		types["resistance"] = 5
		types["chitin"] = 6
		types["flesh"] = 3
		types["speed"] = 5
		
		var n = 15
		
		#for type in types.keys():
		#	for _i in types[type]:
		for _i in n:
			var type = Global.get_random_element(types.keys())
			var input = {}
			input.bienenstock = self
			input.type = type+"man"
			var fehler = Classes_3.Fehler.new(input)
			arr.fehler.append(fehler)
			
			var pfeilers = Global.get_random_element(obj.saal.arr.pfeiler)
			pfeilers[0].add_fehler(fehler)
