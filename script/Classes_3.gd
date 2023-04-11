extends Node


#якорь
class Anker:
	var word = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		word.type = input_.type
		obj.bienenstock = input_.bienenstock
		obj.saal = obj.bienenstock.obj.saal
		obj.pfeiler = input_.pfeiler
		obj.pfeiler.obj.anker = self
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.anker.instantiate()
		scene.myself.position = obj.pfeiler.vec.grid+Vector3(0.5,0,0.5)#y=2.5
		Global.node.game.get_node("Ankers").add_child(scene.myself)
		var color = null
		var mesh = scene.myself.get_node("MeshSphere").mesh
		mesh.material = mesh.material.duplicate()
		
		match obj.pfeiler.color.plane:
			Color.BLACK:
				color = Color.WHITE
			Color.WHITE:
				color = Color.BLACK
		
		mesh.material.albedo_color = color


	func die() -> void:
		obj.saal.arr.anker.erase(self)
		obj.pfeiler.obj.anker = null
		scene.myself.queue_free()


#жук
class Fehler:
	var num = {}
	var word = {}
	var obj = {}
	var scene = {}
	var color = {}


	func _init(input_) -> void:
		num.index = Global.num.index.fehler
		Global.num.index.fehler += 1
		word.type = input_.type
		obj.bienenstock = input_.bienenstock
		obj.saal = obj.bienenstock.obj.saal
		obj.pfeiler = null
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.fehler.instantiate()
		Global.node.game.get_node("Fehlers").add_child(scene.myself)
		update_color()
		get_emlbem()
		scene.myself.visible = false


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
		var step = step_
		
		if obj.pfeiler == null:
			var pfeilers = Global.get_random_element(obj.saal.arr.pfeiler)
			pfeilers[0].add_fehler(self)
			step -= 1
			scene.myself.visible = true
		
		if step > 0:
			var next_grid = Vector3()+obj.pfeiler.vec.grid
			next_grid.x += step
			
			if next_grid.x < obj.saal.num.depth:
				var next_pfeiler = obj.saal.arr.pfeiler[next_grid.z][next_grid.x]
				next_pfeiler.add_fehler(self)
			else:
				boom()


	func boom() -> void:
		obj.pfeiler.remove_fehler(self)
		Global.obj.spielautomat.remove_fehler_after_boom(self)
		#scene.myself.visible = false
		obj.bienenstock.arr.fehler.erase(self)
		obj.bienenstock.arr.trophy.append(self)
		obj.bienenstock.flag.stop = obj.bienenstock.arr.fehler.size() > 0
		scene.myself.queue_free()
		print('boom')


#столб
class Pfeiler:
	var num = {}
	var vec = {}
	var obj = {}
	var arr = {}
	var dict = {}
	var color = {}
	var mesh = {}


	func _init(input_) -> void:
		num.far_away = -1
		vec.grid = Vector3(input_.depth, 0, input_.width)
		obj.saal = input_.saal
		obj.anker = null
		arr.fehler = []
		dict.neighbor = {}
		init_mesh()


	func init_mesh() -> void:
		mesh.plane = MeshInstance3D.new()
		mesh.plane.mesh = PlaneMesh.new()
		mesh.plane.mesh.size = Vector2(1,1)
		mesh.plane.position = vec.grid+Vector3(0.5,0,0.5)
		
		var material = StandardMaterial3D.new()
		material.vertex_color_use_as_albedo = true
		mesh.plane.mesh.surface_set_material(0, material)  
		color.plane = null
		var index = (int(vec.grid.x)+int(vec.grid.z))%2
		
		match index:
			0:
				color.plane = Color.BLACK
			1:
				color.plane = Color.WHITE
		
		mesh.plane.mesh.material.albedo_color = color.plane
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
		var index = arr.fehler.find(fehler_)
		arr.fehler.erase(fehler_)
		
		for fehler in arr.fehler:
			fehler.update_position()


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
		arr.anker = []
		init_pfeilers()


	func init_pfeilers() -> void:
		arr.pfeiler = []
		
		for _i in num.width:
			arr.pfeiler.append([])
			
			for _j in num.depth:
				var input = {}
				input.width = _i
				input.depth = _j
				input.saal = self
				var pfeiler = Classes_3.Pfeiler.new(input)
				arr.pfeiler[_i].append(pfeiler)
		
		set_pfeiler_neighbors()


	func set_pfeiler_neighbors() -> void:
		for pfeilers in arr.pfeiler:
			for pfeiler in pfeilers: 
				for direction in Global.dict.neighbor.linear3:
					var grid = pfeiler.vec.grid+direction
					
					if on_saal_check(grid):
						pfeiler.dict.neighbor[direction] = arr.pfeiler[grid.z][grid.x]


	func get_free_pfeilers() -> Array:
		var pfeilers = []
		
		for pfeilers_ in arr.pfeiler:
			for pfeiler in pfeilers_:
				if pfeiler.arr.fehler.size() == 0:
					pfeilers.append(pfeiler)
					pfeiler.num.far_away = -1
				else:
					pfeiler.num.far_away = 0
		
		var stop_flag = true
		
		while stop_flag:
			stop_flag = false
			
			for pfeiler in pfeilers:
				var distances = [] 
				
				for direction in pfeiler.dict.neighbor.keys():
					var neighbor = pfeiler.dict.neighbor[direction]
					
					if neighbor.num.far_away != -1:
						distances.append(neighbor.num.far_away)
				
				if distances.size() > 0:
					distances.sort_custom(func(a, b): return a < b)
					pfeiler.num.far_away = distances[0]+1
			
			for pfeiler in pfeilers:
				if pfeiler.num.far_away == -1:
					stop_flag = true
		
		return pfeilers


	func on_saal_check(vec_: Vector3) -> bool:
		return vec_.x >= 0 && vec_.x < num.depth && vec_.z >= 0 && vec_.z < num.width


#улей
class Bienenstock:
	var obj = {}
	var arr = {}
	var flag = {}
	var scene = {}


	func _init() -> void:
		flag.end = false
		arr.trophy = []
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
		
		var n = 10
		
		#for type in types.keys():
		#	for _i in types[type]:
		for _i in n:
			var type = Global.get_random_element(types.keys())
			var input = {}
			input.bienenstock = self
			input.type = type+"man"
			var fehler = Classes_3.Fehler.new(input)
			arr.fehler.append(fehler)


	func add_ankers() -> void:
		var types = []
		types.append_array(Global.dict.anker.type)
		types.shuffle()
		var pfeilers = obj.saal.get_free_pfeilers()
		var datas = []
		
		for pfeiler in pfeilers:
			var data = {}
			data.pfeiler = pfeiler
			data.distance = pfeiler.num.far_away
			datas.append(data)
		
		datas.sort_custom(func(a, b): return a.distance < b.distance)
		
		for type in types:
			var options = []
			
			for data in datas:
				var pfeiler = data.pfeiler
				var n = 0
			
				match type:
					"introvert":
						n = pfeiler.num.far_away-1
					"extrovert":
						n = datas[0].distance-pfeiler.num.far_away+1
					"chaotic":
						n = 1
			
				for _i in n:
					options.append(pfeiler)
			
			if options.size() > 0:
				var pfeiler = Global.get_random_element(options)
				var input = {}
				input.type = type
				input.pfeiler = pfeiler
				input.bienenstock = self
				var anker = Classes_3.Anker.new(input)
				obj.saal.arr.anker.append(anker)
				
				for data in datas:
					if data.pfeiler == pfeiler:
						datas.erase(data)
						break
				
				datas.sort_custom(func(a, b): return a.distance < b.distance)


	func clean_ankers() -> void:
		for _i in range(obj.saal.arr.anker.size()-1,-1,-1):
			var anker = obj.saal.arr.anker[_i]
			anker.die()
