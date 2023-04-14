extends Node


#Волшебник
class Zauberer:
	var word = {}
	var obj = {}
	var flag = {}


	func _init(input_) -> void:
		obj.waffe = null
		flag.current = false
		start_waffe()


	func start_waffe() -> void:
		var waffe = Global.get_random_element(Global.brunnen.arr.waffe)
		set_waffe(waffe)


	func set_waffe(waffe_) -> void:
		obj.waffe = waffe_
		obj.waffe.obj.zauberer = self


	func add_waffe_aktions_on_screen():
		if flag.current:
			obj.waffe.add_aktions_on_screen()
