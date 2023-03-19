extends Node


#пуговица
class Knopf:
	var vec = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		vec.grid = input_.grid
		obj.leinwand = input_.leinwand
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.knopf.instantiate()
		scene.myself.set_offset(vec.grid*Global.num.leinwand.a)
		obj.leinwand.scene.myself.get_node("Knopfs").add_child(scene.myself)


#разрез
class Schlitz:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		arr.knopf = input_.knopfs
		arr.klappe = []
		obj.leinwand = input_.leinwand
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.schlitz.instantiate()
		
		for knopf in arr.knopf:
			scene.myself.add_point(knopf.vec.grid*Global.num.leinwand.a)
		
		obj.leinwand.scene.myself.get_node("Schlitzs").add_child(scene.myself)


	func add_klappe(klappe_) -> void:
		if !arr.klappe.has(klappe_):
			arr.klappe.append(klappe_)


#лоскут
class Klappe:
	var arr = {}
	var dict ={}
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		arr.knopf = input_.knopfs
		obj.leinwand = input_.leinwand
		dict.neighbor = {}
		word.color = "White"
		init_schlitzs()
		#init_polygon()


	func init_schlitzs() -> void:
		for _i in arr.knopf.size():
			var _j = (_i+1)%arr.knopf.size()
			var knopfs = [arr.knopf[_i],arr.knopf[_j]]
			
			for _k in knopfs.size():
				var _l = (_k+1)%knopfs.size()
				var first = knopfs[_k]
				var second = knopfs[_l]
				
				if !obj.leinwand.dict.schlitz.keys().has(first):
					obj.leinwand.dict.schlitz[first] = {}
				if !obj.leinwand.dict.schlitz.keys().has(second):
					obj.leinwand.dict.schlitz[second] = {}
				
				if !obj.leinwand.dict.schlitz[first].keys().has(second):
					var input = {}
					input.leinwand = obj.leinwand
					input.knopfs = knopfs
					var schlitz = Classes_1.Schlitz.new(input)
					obj.leinwand.dict.schlitz[first][second] = schlitz
					obj.leinwand.dict.schlitz[second][first] = schlitz
				
				obj.leinwand.dict.schlitz[second][first].add_klappe(self)


	func init_polygon() -> void:
		var vertexs = PackedVector2Array()
		
		for knopf in arr.knopf:
			vertexs.append(knopf.vec.grid*Global.num.leinwand.a)
		
		var polygon = Polygon2D.new()
		polygon.set_polygon(vertexs)
		
		var h = 0.5
		var s = 0.75
		var v = 1
		
		match word.color:
			"White":
				s = 0.0
				v = 1.0
			"Black":
				v = 0.0
			"Red":
				h = 0.0
			"Green":
				h = 120/360.0
			"Blue":
				h = 210.0/360.0
			"Yellow":
				h = 60.0/360.0
		
		polygon.set_color(Color.from_hsv(h,s,v))
		obj.leinwand.scene.myself.get_node("Klappes").add_child(polygon)


#полотно
class Leinwand:
	var arr = {}
	var dict = {}
	var scene = {}


	func _init() -> void:
		dict.schlitz = {}
		scene.myself = Global.scene.leinwand.instantiate()
		Global.node.game.add_child(scene.myself)
		init_knopfs()
		init_klappes()


	func init_knopfs() -> void:
		arr.knopf = []
		
		for _i in Global.num.leinwand.rows:
			arr.knopf.append([])
			
			for _j in Global.num.leinwand.cols:
				var input = {}
				input.leinwand = self
				input.grid = Vector2(_i,_j)
				var knopf = Classes_1.Knopf.new(input)
				arr.knopf[_i].append(knopf)


	func init_klappes() -> void:
		arr.klappe = []
		
		for knopfs in arr.knopf:
			for knopf in knopfs:
				if knopf.vec.grid.x < Global.num.leinwand.rows-1 && knopf.vec.grid.y < Global.num.leinwand.cols-1:
					var input = {}
					input.leinwand = self
					input.knopfs = []
					
					for vector in Global.dict.neighbor.zero:
						var grid = knopf.vec.grid+vector
						input.knopfs.append(arr.knopf[grid.y][grid.x])
					
					var klappe = Classes_1.Klappe.new(input)
					arr.klappe.append(klappe)
		
		set_klappe_neighbors()


	func set_klappe_neighbors() -> void:
		for first_knopf in dict.schlitz.keys():
			for second_knopf in dict.schlitz[first_knopf].keys():
				var schlitz = dict.schlitz[first_knopf][second_knopf]
				
				if schlitz.arr.klappe.size() > 1:
					var first_klappe = schlitz.arr.klappe.front()
					var second_klappe = schlitz.arr.klappe.back()
					first_klappe.dict.neighbor[schlitz] = second_klappe
					second_klappe.dict.neighbor[schlitz] = first_klappe
		
		set_klappe_colors()


	func set_klappe_colors() -> void:
		var origin = arr.klappe[0]
		var unpainted = [origin]
		
		while unpainted.size() > 0:
			var klappe = unpainted.pop_front()
			var colors = []
			colors.append_array(Global.arr.color)
			
			for schlitz in klappe.dict.neighbor.keys():
				var neighbor = klappe.dict.neighbor[schlitz]
				colors.erase(neighbor.word.color)
				
				if neighbor.word.color == "White" && !unpainted.has(neighbor):
					unpainted.append(neighbor)
			
			klappe.word.color = Global.get_random_element(colors)
		
		for klappe in arr.klappe:
			klappe.init_polygon()

