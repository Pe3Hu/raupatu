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
	dict.neighbor.linear = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
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
	


func init_arr() -> void:
	arr.sequence = {} 
	arr.sequence["A000040"] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
	arr.sequence["A000045"] = [89, 55, 34, 21, 13, 8, 5, 3, 2, 1, 1]
	arr.sequence["A000124"] = [7, 11, 16] #, 22, 29, 37, 46, 56, 67, 79, 92, 106, 121, 137, 154, 172, 191, 211]
	arr.sequence["A001358"] = [4, 6, 9, 10, 14, 15, 21, 22, 25, 26]
	arr.sequence["B000000"] = [2, 3, 5, 8, 10, 13, 17, 20, 24, 29, 33, 38]
	arr.color = ["Red","Green","Blue","Yellow"]
	arr.delta = [3,4,5,6,7,8,9]#[2,3,4,5,6,7,8,9,10]


func init_node() -> void:
	node.game = get_node("/root/Game") 
	node.camera = get_node("/root/Game/Camera3D") 


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
	
	vec.angle = {}
	vec.angle.camera = Vector3(-PI/12,PI/3,0)


func init_scene() -> void:
	scene.knopf = load("res://scenes/1/knopf/Knopf.tscn")
	scene.schlitz = load("res://scenes/1/schlitz/Schlitz.tscn")
	scene.zugang = load("res://scenes/1/zugang/Zugang.tscn")
	scene.leinwand = load("res://scenes/1/leinwand/Leinwand.tscn")
	scene.fehler = load("res://scenes/3/fehler/Fehler.tscn")
	scene.zeitspanne = load("res://scenes/3/zeitspanne/Zeitspanne.tscn")
	scene.zeitleiste = load("res://scenes/3/zeitleiste/Zeitleiste.tscn")
	scene.fehler = load("res://scenes/3/fehler/Fehler.tscn")
	scene.spielautomat = load("res://scenes/4/spielautomat/Spielautomat.tscn")


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
