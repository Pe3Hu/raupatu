extends Node


var rng = RandomNumberGenerator.new()
var num = {}
var dict = {}
var arr = {}
var obj = {}
var node = {}
var flag = {}
var vec = {}
var scene = {}

var mouse_pressed = false


func init_num() -> void:
	num.index = {}
	num.index.knopf = 0
	num.index.fehler = 0
	
	num.leinwand = {}
	num.leinwand.n = 6
	num.leinwand.rows = num.leinwand.n
	num.leinwand.cols = num.leinwand.n
	num.leinwand.a = 144
	
	num.delta = {}
	num.delta.max = 12
	
	num.saal = {}
	num.saal.height = 10
	num.saal.width = 3
	num.saal.depth = 7
	
	num.pielautomat = {}
	num.pielautomat.height = 3
	num.pielautomat.width = 5


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	
	dict.klappe = {}
	dict.klappe.size = {
		1: [["corner"], ["center"]],
		2: [["corner", "corner"], ["corner", "center"], ["center", "center"]],
		3: [["corner", "corner", "center"], ["corner", "center", "center"]],
		4: [["corner", "corner", "corner", "corner"]]
	}
	dict.klappe.duplicate = {
		1: 8,
		2: 4,
		3: 2,
		4: 1
	}
	
	dict.fehler = {}
	dict.fehler.aspect = ["dodge","armour","resistance","chitin","flesh","speed"]
	dict.fehler.repeatability = {
		"none": 1,
		"dodge": 3,
		"armour": 2,
		"resistance": 2,
		"chitin": 1,
		"flesh": 1,
		"speed": 3,
		"": 1,
	}
	
	init_emblems()
	init_aktions()
	init_waffes()
	
	dict.anker = {}
	dict.anker.type = ["introvert","extrovert","chaotic"]


func init_emblems() -> void:
	dict.emlbem = {}
	var path = "res://asset/json/emblem_path.json"
	dict.emlbem.path = load_data(path)
	dict.emlbem.type = []
	
	for type in dict.emlbem.path.keys():
		for subtype in dict.emlbem.path[type].keys():
			for name_ in dict.emlbem.path[type][subtype]:
				var data_ = {}
				data_.type = type
				data_.subtype = subtype
				data_.name = name_
				dict.emlbem.type.append(data_)
	
	dict.emlbem.aspect = {}
	
	for aspect in dict.fehler.repeatability.keys():
		dict.emlbem.aspect[aspect] = []
		dict.emlbem.aspect[aspect].append_array(dict.emlbem.type)


func init_aktions() -> void:
	dict.aktion = {}
	var path = "res://asset/json/aktion_data.json"
	var array = load_data(path)
	dict.aktion.parameter = {}
	dict.aktion.name = {}
	dict.aktion.primordial = {}
	
	for key in array.front().keys():
		if key != "Name":
			dict.aktion.parameter[key] = []
	
	for aktion in array:
		dict.aktion.name[aktion["Name"]] = aktion.duplicate()
		
		if aktion["Waffe"] == "Primordial":
			dict.aktion.primordial[aktion["Name"]] = aktion.duplicate()
		
		for key in dict.aktion.parameter.keys():
			if !dict.aktion.parameter[key].has(aktion[key]):
				dict.aktion.parameter[key].append(aktion[key])
	
	
	for key in dict.aktion.primordial.keys():
		var aktion = dict.aktion.primordial[key]
		aktion.erase("Waffe")
		aktion.erase("Name")


func init_waffes() -> void:
	dict.waffe = {}
	var path = "res://asset/json/waffe_data.json"
	var array = load_data(path)
	dict.waffe.type = {}
	dict.waffe.abbreviation = {}
	
	for key in array.front().keys():
		if key != "Type":
			var abbreviation = ""
			var words = key.split(" ",true,5)
			
			for word in words:
				if word != "of" && word != "the":
					abbreviation += word[0].to_upper()
				
			dict.waffe.abbreviation[key] = abbreviation
	
	for waffe in array:
		var data = {}
		
		for key in waffe.keys():
			if key != "Type":
				var abbreviation = dict.waffe.abbreviation[key]
				data[abbreviation] = waffe[key]
		
		dict.waffe.type[waffe["Type"]] = data


func init_arr() -> void:
	arr.sequence = {} 
	arr.sequence["A000040"] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
	arr.sequence["A000045"] = [89, 55, 34, 21, 13, 8, 5, 3, 2, 1, 1]
	arr.sequence["A000124"] = [7, 11, 16] #, 22, 29, 37, 46, 56, 67, 79, 92, 106, 121, 137, 154, 172, 191, 211]
	arr.sequence["A001358"] = [4, 6, 9, 10, 14, 15, 21, 22, 25, 26]
	arr.sequence["B000000"] = [2, 3, 5, 8, 10, 13, 17, 20, 24, 29, 33, 38]
	arr.color = ["Red","Green","Blue","Yellow"]
	arr.delta = [3,4,5,6,7,8,9]#[2,3,4,5,6,7,8,9,10]
	arr.wave = ["uppercut","overhand","hook","jab"]


func init_node() -> void:
	node.game = get_node("/root/Game") 
	node.camera = get_node("/root/Game/Camera/Camera3D") 
	node.spielautomat = get_node("/root/Game/Camera/Spielautomat") 
	node.kachelns = get_node("/root/Game/Camera/Spielautomat/Kachelns") 
	node.aktions = get_node("/root/Game/Camera/AktionPanel/Aktions") 
	


func init_flag() -> void:
	flag.click = false
	flag.stop = false


func init_vec() -> void:
	vec.size = {}
	
	vec.scale = {}
	
	vec.center = {}
	vec.center.spielautomat = Vector3(3,3,8)
	
	vec.shift = {}
	vec.shift.spielautomat = Vector3(-3,0,-6)
	#vec.shift.aktion = Vector3(7.4,2.2,8.6)
	
	vec.angle = {}
	vec.angle.camera = Vector3(-PI/12,PI/3,0)
	
	vec.position = {}
	vec.position.camera = {}
	vec.position.camera[3] = Vector3(8.6,2.2,8)
	vec.position.camera[4] = Vector3(9,2.4,9.2)
	vec.position.camera[5] = Vector3(9.2,2.6,10.4)
	vec.position.camera[6] = Vector3(9.3,2.6,11.4)
	vec.position.camera[7] = Vector3(9.4,2.6,12.4)



func init_scene() -> void:
	scene.knopf = load("res://scene/1/knopf/Knopf.tscn")
	scene.schlitz = load("res://scene/1/schlitz/Schlitz.tscn")
	scene.zugang = load("res://scene/1/zugang/Zugang.tscn")
	scene.leinwand = load("res://scene/1/leinwand/Leinwand.tscn")
	scene.fehler = load("res://scene/3/fehler/Fehler.tscn")
	scene.fehler = load("res://scene/3/fehler/Fehler.tscn")
	scene.anker = load("res://scene/3/anker/Anker.tscn")
	scene.spielautomat = load("res://scene/4/spielautomat/Spielautomat.tscn")
	scene.aktion = load("res://scene/5/aktion/Aktion.tscn")


func _ready() -> void:
	init_dict()
	init_num()
	init_arr()
	init_node()
	init_flag()
	init_vec()
	init_scene()


func get_random_element(arr_: Array):
	if arr_.size() == 0:
		print("!bug! empty array in get_random_element func")
		return null
	
	rng.randomize()
	var index_r = rng.randi_range(0, arr_.size()-1)
	return arr_[index_r]


func split_two_point(points_: Array, delta_: float):
	var a = points_.front()
	var b = points_.back()
	var x = (a.x+b.x*delta_)/(1+delta_)
	var y = (a.y+b.y*delta_)/(1+delta_)
	var point = Vector2(x, y)
	return point


func save(path_: String, data_: String):
	var path = path_+".json"
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.save(data_)
	file.close()


func load_data(path_: String):
	var file = FileAccess.open(path_,FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()
