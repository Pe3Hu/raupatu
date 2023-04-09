extends Node



#Символ
class Symbol:
	var obj = {}


	func _init(input_) -> void:
		obj.rolle = input_.rolle
		obj.fehler = input_.fehler


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
		vec.shift = Vector3(1,0,0)
		init_plane()
		init_sprite()


	func init_plane() -> void:
		mesh.plane = MeshInstance3D.new()
		mesh.plane.mesh = PlaneMesh.new()
		mesh.plane.mesh.size = Vector2(1,1)
		mesh.plane.position = Global.node.spielautomat.position
		mesh.plane.mesh.center_offset = Global.vec.shift.spielautomat
		mesh.plane.mesh.center_offset.y += num.order.current-(Global.num.pielautomat.height+1)/2
		mesh.plane.mesh.center_offset.x += obj.rolle.num.col-Global.num.pielautomat.width/2
		
		var material = StandardMaterial3D.new()
		#material.vertex_color_use_as_albedo = true
		mesh.plane.mesh.surface_set_material(0, material)  
		var color = Color.SLATE_GRAY
		mesh.plane.mesh.material.albedo_color = color
	
		mesh.plane.mesh.set_orientation(2)
		mesh.plane.set_cast_shadows_setting(0)
		mesh.plane.rotation = Global.node.camera.rotation
		obj.spielautomat.scene.myself.add_child(mesh.plane)


	func init_sprite() -> void:
		mesh.sprite = Sprite3D.new()
		mesh.sprite.position += mesh.plane.mesh.center_offset
		
		if on_screen():
			mesh.sprite.position.z += 0.01
			
		mesh.sprite.scale *= 0.4
		mesh.plane.add_child(mesh.sprite)


	func set_symbol(symbol_) -> void:
		obj.symbol = symbol_
		var path = "res://asset/png/emblem/"
		
		if obj.symbol.obj.fehler != null:
			var data = obj.symbol.obj.fehler.word.emblem
			path += data.type+"/"+data.subtype+"/"+data.name+".png"
		else:
			path += "empty.png"
		
		var texture = load(path)
		mesh.sprite.set_texture(texture)
		
		if obj.symbol.obj.fehler != null:
			mesh.plane.mesh.material.albedo_color = obj.symbol.obj.fehler.color.cube
		else:
			mesh.plane.mesh.material.albedo_color = Color.SLATE_GRAY


	func on_screen() -> bool:
		return num.order.current != 0 && num.order.current != 4


#Рулон
class Rolle:
	var num = {}
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		num.col = input_.col
		num.index = 0
		obj.spielautomat = input_.spielautomat
		init_symbols()
		init_kachelns()


	func init_symbols() -> void:
		arr.symbol = []
		
		for fehler in Global.obj.bienenstock.arr.fehler:
			var type = fehler.word.type
			type = type.left(type.length() - 3)
			var repeatability = Global.dict.fehler.repeatability[type]
			
			for _i in repeatability:
				var input = {}
				input.fehler = fehler
				input.rolle = self
				var symbol = Classes_4.Symbol.new(input)
				arr.symbol.append(symbol)
		
		
		for _i in Global.num.pielautomat.height:
				var input = {}
				input.fehler = null
				input.rolle = self
				var symbol = Classes_4.Symbol.new(input)
				arr.symbol.append(symbol)
		
		arr.symbol.shuffle()


	func init_kachelns() -> void:
		arr.kacheln = []
		
		for _i in Global.num.pielautomat.height+2:
			var input = {}
			input.order = _i
			input.rolle = self
			var kacheln = Classes_4.Kacheln.new(input)
			arr.kacheln.append(kacheln)
		
		fill_kachelns()


	func fill_kachelns() -> void:
		for _i in arr.kacheln.size():
			var index = (_i+num.index)%arr.symbol.size()
			var kacheln = arr.kacheln[_i]
			var symbol = arr.symbol[index]
			kacheln.set_symbol(symbol)


	func roll() -> void:
		var min_step = arr.symbol.size()/2
		var max_step = arr.symbol.size()+min_step
		Global.rng.randomize()
		var step = Global.rng.randi_range(min_step,max_step)
		num.index = (step+num.index)%arr.symbol.size()
		fill_kachelns()
		fehler_jumps()


	func fehler_jumps() -> void:
		for kacheln in arr.kacheln:
			if kacheln.on_screen() && kacheln.obj.symbol.obj.fehler != null:
				var step = 1
				kacheln.obj.symbol.obj.fehler.jump(step)


	func remove_fehler(fehler_) -> void:
		for _i in range(arr.symbol.size()-1,-1,-1):
			if arr.symbol[_i].obj.fehler == fehler_:
				arr.symbol.erase(arr.symbol[_i])


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


	func next_turn() -> void:
		Global.obj.bienenstock.clean_ankers()
		
		for rolle in arr.rolle:
			rolle.roll()
		
		if !Global.obj.bienenstock.flag.end:
			Global.obj.bienenstock.add_ankers()


	func remove_fehler_after_boom(fehler_) -> void:
		for rolle in arr.rolle:
			rolle.remove_fehler(fehler_)
		
