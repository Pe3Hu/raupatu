extends Node


#Мозг
class Gehirn:
	var obj ={}


	func _init(input_) -> void:
		obj.zauberer = input_.zauberer


	func evaluate_aktions() -> void:
		var aktions = obj.zauberer.get_aktions()
		var ankers = []
		ankers.append_array(Global.obj.bienenstock.obj.saal.arr.anker)
		var versions = []
		
		for anker in ankers:
			for fehler in Global.obj.bienenstock.arr.fehler:
				if fehler.vec.grid != null:
					var d = Global.get_manhattan_distance(anker.obj.pfeiler.vec.grid,fehler.vec.grid)
					
					for aktion in aktions:
						if d >= aktion.num.parameter["Minimal range"] && d <= aktion.num.parameter["Maximum range"]:
							var version = {}
							version.fehler = fehler
							version.anker = anker
							version.aktion = aktion
							versions.append(version)


#Волшебник
class Zauberer:
	var word = {}
	var arr = {}
	var obj = {}
	var flag = {}


	func _init(input_) -> void:
		obj.hexenzirkel = input_.hexenzirkel
		obj.waffe = null
		flag.current = false
		init_gehirn()
		start_waffe()
		start_primordial()
		flag.current = true
		add_waffe_aktions_on_screen()


	func init_gehirn() -> void:
		var input = {}
		input.zauberer = self
		obj.gehirn = Classes_5.Gehirn.new(input)


	func start_waffe() -> void:
		var waffe = Global.get_random_element(Global.obj.brunnen.arr.waffe)
		set_waffe(waffe)


	func set_waffe(waffe_) -> void:
		obj.waffe = waffe_
		obj.waffe.obj.zauberer = self


	func start_primordial() -> void:
		arr.primordial = []
		var bigs = []
		var smalls = []
		
		for key in Global.dict.aktion.primordial.keys():
			var aktion = Global.dict.aktion.primordial[key]
			
			if key.find("Small"):
				smalls.append(key)
				
			if key.find("Big"):
				bigs.append(key)
		
		var input = {}
		input.name = Global.get_random_element(smalls)
		input.waffe = obj.waffe
		var aktion = Classes_2.Aktion.new(input)
		arr.primordial.append(aktion)
		
		input = {}
		input.name = Global.get_random_element(bigs)
		input.waffe = obj.waffe
		aktion = Classes_2.Aktion.new(input)
		arr.primordial.append(aktion)


	func add_primordial_aktions_on_screen() -> void:
		for _i in arr.primordial.size():
			var node = arr.primordial[_i].scene.myself
			Global.node.aktions.add_child(node)
			node.position.x += 2.7+1.8*_i


	func add_waffe_aktions_on_screen() -> void:
		if flag.current:
			obj.waffe.add_aktions_on_screen()
			add_primordial_aktions_on_screen()


	func get_aktions() -> Array:
		var aktions = []
		aktions.append_array(arr.primordial)
		aktions.append_array(obj.waffe.arr.aktion)
		return aktions


	func get_plans() -> Array:
		var plans = []
		obj.gehirn.evaluate_aktions()
		return plans



#Ковен
class Hexenzirkel:
	var arr = {}
	var flag = {}


	func _init() -> void:
		init_zauberers()
		flag.end_turn = true


	func init_zauberers() -> void:
		arr.zauberer = []
		var n = 1
		
		for _i in n:
			var input = {}
			input.hexenzirkel = self
			var zauberer = Classes_5.Zauberer.new(input)
			arr.zauberer.append(zauberer)


	func zauberers_turn() -> void:
		var plans = {}
		
		for zauberer in arr.zauberer:
			plans[zauberer] = zauberer.get_plans()
		

