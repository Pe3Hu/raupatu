extends Node


#жук
class Fehler:
	var num = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		num.index = Global.num.index.fehler
		Global.num.index.fehler += 1
		obj.bienenstock = input_.bienenstock
		obj.zeitspanne = null
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.fehler.instantiate()
		var text = "A"+str(num.index)
		scene.myself.set_label_text(text)


#период времени
class Zeitspanne:
	var obj = {}
	var arr = {}
	var scene = {}


	func _init(input_) -> void:
		obj.zeitleiste = input_.zeitleiste
		arr.fehler = []
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.zeitspanne.instantiate()
		obj.zeitleiste.scene.myself.add_child(scene.myself)
		Global.node.game.add_child(scene.myself)


	func add_fehler(fehler_) -> void:
		if fehler_.obj.zeitspanne != null:
			fehler_.obj.zeitspanne.remove_fehler(fehler_)
		
		arr.fehler.append(fehler_)
		scene.myself.add_child(fehler_.scene.myself)


	func remove_fehler(fehler_) -> void:
		arr.fehler.erase(fehler_)


#временная шкала
class Zeitleiste:
	var num = {}
	var obj = {}
	var dict = {}
	var scene = {}


	func _init(input_) -> void:
		obj.bienenstock = input_.bienenstock
		num.zeitspannes = input_.zeitspannes
		init_scene()
		init_zeitspannes()


	func init_scene() -> void:
		scene.myself = Global.scene.zeitleiste.instantiate()
		Global.node.game.add_child(scene.myself)


	func init_zeitspannes() -> void:
		dict.zeitspanne = {}
		
		for _i in num.zeitspannes:
			var input = {}
			input.index = _i
			input.zeitleiste = self
			dict.zeitspanne[_i] = Classes_3.Zeitspanne.new(input)


#взломщик
class Einbrecher:
	var obj = {}


	func _init(input_) -> void:
		obj.notizbuch = input_.notizbuch
		obj.chiffre = input_.chiffre


#улей
class Bienenstock:
	var obj = {}
	var arr = {}


	func _init() -> void:
		init_zeitleiste()
		init_fehlers()


	func init_zeitleiste() -> void:
		var input = {}
		input.zeitspannes = 4
		input.bienenstock = self
		obj.zeitleiste = Classes_3.Zeitleiste.new(input)


	func init_fehlers() -> void:
		arr.fehler = []
		var n = 10
		
		for _i in n:
			var input = {}
			input.bienenstock = self
			var fehler = Classes_3.Fehler.new(input)
			arr.fehler.append(fehler)
			
			var index = Global.get_random_element(obj.zeitleiste.dict.zeitspanne.keys())
			#var index = 1
			var zeitspanne = obj.zeitleiste.dict.zeitspanne[index]
			zeitspanne.add_fehler(fehler)
