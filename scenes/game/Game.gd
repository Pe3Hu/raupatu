extends Control


func _ready():
	#Global.obj.leinwand = Classes_1.Leinwand.new()
	Global.obj.bienenstock = Classes_3.Bienenstock.new()
#	datas.sort_custom(Classes_0.Sorter, "sort_ascending")


func _input(event):
	if event is InputEventMouseButton:
		Global.mouse_pressed = !Global.mouse_pressed
	else:
		Global.mouse_pressed = !Global.mouse_pressed


func _process(delta):
	$FPS.text = str(Engine.get_frames_per_second())
