extends Node


#шифр
class Chiffre:
	var obj = {}


	func _init(input_) -> void:
		pass


#предположение
class Annahme:
	var obj = {}


	func _init(input_) -> void:
		pass


#блокнот
class Notizbuch:
	var obj = {}


	func _init(input_) -> void:
		pass


#взломщик
class Einbrecher:
	var obj = {}


	func _init(input_) -> void:
		obj.notizbuch = input_.notizbuch
		obj.chiffre = input_.chiffre


#тайник
class Versteck:
	var obj = {}


	func _init(input_) -> void:
		#вор
		obj.dieb = input_.dieb
		#владелец
		obj.besitzer = input_.besitzer
