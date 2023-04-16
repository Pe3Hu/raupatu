extends Node


#Волшебник
class Zauberer:
	var word = {}
	var arr ={}
	var obj = {}
	var flag = {}


	func _init(input_) -> void:
		obj.hexenzirkel = input_.hexenzirkel
		obj.waffe = null
		flag.current = false
		start_waffe()
		start_primordial()
		flag.current = true
		add_waffe_aktions_on_screen()


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


	func add_primordial_on_screen() -> void:
		for _i in arr.primordial.size():
			var node = arr.primordial[_i].scene.myself
			Global.node.aktions.add_child(node)
			node.position.x += 2.7+1.8*_i


	func add_waffe_aktions_on_screen() -> void:
		if flag.current:
			obj.waffe.add_aktions_on_screen()
			add_primordial_on_screen()


#Ковен
class Hexenzirkel:
	var arr ={}


	func _init() -> void:
		init_zauberers()


	func init_zauberers() -> void:
		arr.zauberer = []
		var n = 1
		
		for _i in n:
			var input = {}
			input.hexenzirkel = self
			var zauberer = Classes_5.Zauberer.new(input)
			arr.zauberer.append(zauberer)
