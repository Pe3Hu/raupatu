extends Node


#Действие
class Aktion:
	var num = {}
	var word = {}
	var obj = {}
	var scene = {}
	var flag = {}


	func _init(input_) -> void:
		word.name = input_.name
		obj.waffe = input_.waffe
		obj.zauberer = null
		calc_parameters()


	func calc_parameters() -> void:
		num.parameter = {}
		word.parameter = {}
		
		for parameter in Global.dict.aktion.name[word.name].keys():
			var value = Global.dict.aktion.name[word.name][parameter]
			
			match typeof(value):
				3:
					num.parameter[parameter] = value
				4:
					word.parameter[parameter] = value
		
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.aktion.instantiate()
		scene.myself.set_labels(self)


#Орудие
class Waffe:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}


	func _init(input_) -> void:
		word.type = input_.type
		word.name = ""
		obj.brunnen = input_.brunnen
		obj.zauberer = null
		parameterize()
		set_aktions()


	func parameterize() -> void:
		var data = Global.dict.waffe.type[word.type]
		num.damage = {}
		num.damage.bot = data["BDB"]
		num.damage.top = data["BDT"]
		Global.rng.randomize()
		var bot_rnd = Global.rng.randi_range(data["SBR"], data["SBI"])
		num.damage.bot += bot_rnd
		Global.rng.randomize()
		var top_rnd = Global.rng.randi_range(data["STR"], data["STI"])
		num.damage.top += top_rnd


	func set_aktions() -> void:
		arr.aktion = []
		
		for key in Global.dict.aktion.name.keys():
			if Global.dict.aktion.name[key]["Waffe"] == word.type:
				var input = {}
				input.name = key
				input.waffe = self
				var aktion = Classes_2.Aktion.new(input)
				arr.aktion.append(aktion)


	func add_aktions_on_screen() -> void:
		for _i in arr.aktion.size():
			var node = arr.aktion[_i].scene.myself
			Global.node.aktions.add_child(node)
			node.position.x += -4.5+1.8*_i


#Фонтан
class Brunnen:
	var arr = {}


	func _init() -> void:
		init_waffes()


	func init_waffes() -> void:
		arr.waffe = []
		var n = 1
		var types = ["Bow"]
		
		for _i in n:
			for type in types:
				var input = {}
				input.type = type
				input.brunnen = self
				var waffe = Classes_2.Waffe.new(input)
				arr.waffe.append(waffe)


	func check_waffe():
#		var min = 1000
#		var max = 0
#
#		for waffe in arr.waffe:
#			if waffe.num.damage.top > max:
#				max = waffe.num.damage.top
#			if waffe.num.damage.bot < min:
#				min = waffe.num.damage.bot
		pass
