extends Node


#Орудие
class Waffe:
	var num = {}
	var word = {}
	var obj = {}


	func _init(input_) -> void:
		word.type = input_.type
		word.name = ""
		obj.brunnen = input_.brunnen
		obj.zauberer = null
		parameterize()


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


#Фонтан
class Brunnen:
	var arr = {}


	func _init() -> void:
		init_waffes()


	func init_waffes() -> void:
		arr.waffe = []
		var n = 1
		var types = ["Knuckles"]
		
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
