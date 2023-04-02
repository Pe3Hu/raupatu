extends Node


#жук
class Fehler:
	var num = {}
	var obj = {}
	var mesh = {}
	var color = {}


	func _init(input_) -> void:
		num.index = Global.num.index.fehler
		Global.num.index.fehler += 1
		obj.bienenstock = input_.bienenstock
		obj.pfeiler = null
		init_mesh()


	func init_mesh() -> void:
		mesh.cube = MeshInstance3D.new()
		mesh.cube.mesh = BoxMesh.new()
		mesh.cube.mesh.size.y = 0.5
		
		var material = StandardMaterial3D.new()
		material.vertex_color_use_as_albedo = true
		mesh.cube.mesh.surface_set_material(0, material)  
		var color_name = Global.get_random_element(Global.arr.color)
		color.cube = Color.from_string(color_name, "Black")
		print(color_name)
		mesh.cube.mesh.material.albedo_color = color.cube
		Global.node.game.add_child(mesh.cube)


	func update_position() -> void:
		var position = obj.pfeiler.vec.grid
		position.y += obj.pfeiler.arr.fehler.find(self)*0.5
		mesh.cube.position = position+mesh.cube.mesh.size*0.5


#столб
class Pfeiler:
	var vec = {}
	var obj = {}
	var arr = {}
	var scene = {}


	func _init(input_) -> void:
		vec.grid = Vector3(input_.width, 0, input_.depth)
		obj.saal = input_.saal
		arr.fehler = []


	func add_fehler(fehler_) -> void:
		if fehler_.obj.pfeiler != null:
			fehler_.obj.pfeiler.remove_fehler(fehler_)
		
		arr.fehler.append(fehler_)
		fehler_.obj.pfeiler = self
		fehler_.update_position()


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
		scene.myself = Global.scene.cube.instantiate()
		
		#scene.myself.set_vertices()


	func init_saal() -> void:
		var input = {}
		input.height = 10
		input.width = 3
		input.depth = 7
		input.bienenstock = self
		obj.saal = Classes_3.Saal.new(input)


	func init_fehlers() -> void:
		arr.fehler = []
		var n = 10
		
		for _i in n:
			var input = {}
			input.bienenstock = self
			var fehler = Classes_3.Fehler.new(input)
			arr.fehler.append(fehler)
			
			#var pfeiler = obj.saal.arr.pfeiler[0][0]
			var pfeilers = Global.get_random_element(obj.saal.arr.pfeiler)
			pfeilers[0].add_fehler(fehler)
