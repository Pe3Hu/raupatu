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
	
	num.leinwand = {}
	num.leinwand.n = 10
	num.leinwand.rows = num.leinwand.n
	num.leinwand.cols = num.leinwand.n
	num.leinwand.a = 72
	
	num.delta = {}
	num.delta.max = 12


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


func init_flag() -> void:
	flag.click = false
	flag.stop = false


func init_vec() -> void:
	vec.size = {}
	vec.size.champ = Vector2(4, 4)
	
	vec.scale = {}
	vec.scale.continent = Vector2(0.25, 0.25)


func init_scene() -> void:
	scene.knopf = load("res://scenes/knopf/Knopf.tscn")
	scene.schlitz = load("res://scenes/schlitz/Schlitz.tscn")
	scene.leinwand = load("res://scenes/leinwand/Leinwand.tscn")


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
