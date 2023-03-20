extends Node


#пуговица
class Knopf:
	var num = {}
	var word = {}
	var vec = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		word.type = input_.type
		num.index = Global.num.index.knopf
		Global.num.index.knopf += 1
		vec.position = input_.position
		obj.leinwand = input_.leinwand
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.knopf.instantiate()
		scene.myself.set_offset(vec.position)
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
		obj.leinwand.dict.schlitz[arr.knopf.front()][arr.knopf.back()] = self
		obj.leinwand.dict.schlitz[arr.knopf.back()][arr.knopf.front()] = self
		#init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.schlitz.instantiate()
		
		for knopf in arr.knopf:
			scene.myself.add_point(knopf.vec.position)
		
		obj.leinwand.scene.myself.get_node("Schlitzs").add_child(scene.myself)


	func add_klappe(klappe_) -> void:
		if !arr.klappe.has(klappe_):
			arr.klappe.append(klappe_)


	func cut():
		var delta = 1.0/Global.num.delta.max*2
		delta *= Global.get_random_element(Global.arr.delta)
		
		var points = []
		var first = arr.knopf.front()
		var second = arr.knopf.back()
		points.append(first.vec.position)
		points.append(second.vec.position)
		var dot = Global.split_two_point(points, delta)
		
		var input = {}
		input.type = "edge"
		input.leinwand = obj.leinwand
		input.position = Vector2(ceil(dot.x), ceil(dot.y))
		var knopf = Classes_1.Knopf.new(input)
		obj.leinwand.dict.knopf[knopf] = knopf
		
		obj.leinwand.dict.schlitz[first].erase(second)
		obj.leinwand.dict.schlitz[second].erase(first)
		
		obj.leinwand.dict.schlitz[knopf] = {}
		input = {}
		input.leinwand = obj.leinwand
		input.knopfs = [first,knopf]
		var schlitz = Classes_1.Schlitz.new(input)
		input.knopfs = [second,knopf]
		schlitz = Classes_1.Schlitz.new(input)


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
				
				obj.leinwand.dict.schlitz[second][first].add_klappe(self)


	func init_polygon() -> void:
		var vertexs = PackedVector2Array()
		
		for knopf in arr.knopf:
			vertexs.append(knopf.vec.position)
		
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


	func cut() -> void:
		var knopfs = []
#		var schlitzs = []
#		schlitzs.append_array(dict.neighbor.keys())
#		var schlitz = Global.get_random_element(schlitzs)
#		var first = schlitz.cut()
#		knopfs.append(first)
#		schlitzs.erase(schlitz)
#		schlitz = Global.get_random_element(schlitzs)
#		var second = schlitz.cut()
#		knopfs.append(second)
		
#		var input = {}
#		input.leinwand = obj.leinwand
#		input.knopfs = knopfs
#		schlitz = Classes_1.Schlitz.new(input)
#		obj.leinwand.dict.schlitz[first] = {}
#		obj.leinwand.dict.schlitz[first][second] = schlitz
#		obj.leinwand.dict.schlitz[second] = {}
#		obj.leinwand.dict.schlitz[second][first] = schlitz
		pass


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
		add_new_schlitzs()


	func init_knopfs() -> void:
		dict.knopf = {}
		
		for _i in Global.num.leinwand.rows:
			for _j in Global.num.leinwand.cols:
				var input = {}
				input.type = "corner"
				input.leinwand = self
				input.position = Vector2(_i,_j)*Global.num.leinwand.a
				var knopf = Classes_1.Knopf.new(input)
				dict.knopf[input.position] = knopf


	func init_klappes() -> void:
		var border = Vector2(Global.num.leinwand.rows-1,Global.num.leinwand.cols-1)*Global.num.leinwand.a
		arr.klappe = []
		
		for key in dict.knopf.keys():
			if key.x < border.x && key.y < border.y:
				var input = {}
				input.leinwand = self
				input.knopfs = []
				
				for neighbor in Global.dict.neighbor.zero:
					var position = key+neighbor*Global.num.leinwand.a
					input.knopfs.append(dict.knopf[position])
				
				var klappe = Classes_1.Klappe.new(input)
				klappe.init_schlitzs()
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


	func add_new_schlitzs() -> void:
		var schlitzs = []
		
		for first in dict.schlitz.keys():
			for second in dict.schlitz[first].keys():
				var schlitz = dict.schlitz[first][second]
				
				if !schlitzs.has(schlitz):
					schlitzs.append(schlitz)
		
		for schlitz in schlitzs:
			schlitz.cut()
		
		rework_klappes()


	func rework_klappes() -> void:
		arr.klappe = []
		var edges = []
		var centers = {}
		
		for key in dict.knopf.keys():
			var knopf = dict.knopf[key]
			
			match knopf.word.type:
				"corner":
					for _i in dict.schlitz[knopf].keys().size():
						var first = dict.schlitz[knopf].keys()[_i]
						
						for _j in range(_i,dict.schlitz[knopf].keys().size()):
							var second = dict.schlitz[knopf].keys()[_j]
							
							if first.vec.position.x != second.vec.position.x && first.vec.position.y != second.vec.position.y:
								var input = {}
								input.leinwand = self
								input.knopfs = [knopf,first,second]
								var klappe = Classes_1.Klappe.new(input)
								arr.klappe.append(klappe)
				"edge":
					edges.append(knopf)
		
		for _i in Global.num.leinwand.rows-1:
			for _j in Global.num.leinwand.cols-1:
				var center = Vector2(_i+0.5,_j+0.5)*Global.num.leinwand.a
				centers[center] = []
				
				for edge in edges:
					var d = abs(edge.vec.position.x-center.x)+abs(edge.vec.position.y-center.y)
					
					if d < Global.num.leinwand.a:
						centers[center].append(edge)
		
		for key in centers.keys():
			var trios = [[],[]]
			trios[0].append_array(centers[key])
			trios[1].append_array(centers[key])
			var first = Global.get_random_element(trios[0])
			trios[0].erase(first)
			var second = null
			
			for knopf in trios[0]:
				var x = abs(knopf.vec.position.x-first.vec.position.x)
				var y = abs(knopf.vec.position.y-first.vec.position.y)
				
				if x == Global.num.leinwand.a || y == Global.num.leinwand.a:
					second = knopf
					break
			
			trios[1].erase(second)
			
			for trio in trios:
				var input = {}
				input.leinwand = self
				input.knopfs = trio
				var klappe = Classes_1.Klappe.new(input)
				arr.klappe.append(klappe)
		
		
		set_klappe_neighbors()
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

