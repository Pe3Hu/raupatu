extends Node



#подступ
class Zugang:
	var obj = {}
	var arr = {}
	var word = {}
	var scene = {}


	func _init(input_) -> void:
		obj.schlitz = input_.schlitz
		obj.lager = input_.lager
		obj.leinwand = input_.leinwand
		init_knopfs()
		init_scene()


	func init_knopfs() -> void:
		arr.knopf = []
		arr.knopf.append(obj.lager)
		arr.knopf.append_array(obj.schlitz.arr.knopf)
		arr.knopf.append(obj.lager)
		scene.myself = Global.scene.schlitz.instantiate()


	func init_scene() -> void:
		scene.myself = Global.scene.zugang.instantiate()
		
		for knopf in arr.knopf:
			scene.myself.add_point(knopf.vec.position)
		
		obj.leinwand.scene.myself.get_node("Zugangs").add_child(scene.myself)


	func init_polygon() -> void:
		var vertexs = PackedVector2Array()
		
		for knopf in arr.knopf:
			vertexs.append(knopf.vec.position)
		
		var polygon = Polygon2D.new()
		polygon.set_polygon(vertexs)
		
		var h = 0.5
		var s = 0.75
		var v = 1
		word.color = "Black"
		
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
