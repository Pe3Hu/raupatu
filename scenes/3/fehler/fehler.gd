extends Node3D



func _ready() -> void:
	init_mesh()


func set_vertices() -> void:
	var a := Vector3(0, 0.5, 0) 
	var b := Vector3(1, 0.5, 0) 
	var c := Vector3(1, 0, 0) 
	var d := Vector3(0, 0, 0)
	var e := Vector3(0, 0.5, 1)
	var f := Vector3(1, 0.5, 1)
	var g := Vector3(1, 0, 1)
	var h := Vector3(0, 0, 1)
	
	var vertices := [   # faces 
		b,a,d,  b,d,c,  # N
		e,f,g,  e,g,h,  # S
		a,e,h,  a,h,d,  # W
		f,b,c,  f,c,g,  # E
		a,b,f,  a,f,e,  # T
		h,g,c,  h,c,d,  # B
	]
	
	var color = Color.RED
	var colors := []
	
	for i in range(vertices.size()):
		colors.append(color)
	
	$Mesh.mesh = ArrayMesh.new()
	
	var arrays := []
	arrays.resize($Mesh.mesh.ARRAY_MAX)
	arrays[$Mesh.mesh.ARRAY_VERTEX] = PackedVector3Array(vertices)
	arrays[$Mesh.mesh.ARRAY_COLOR] = PackedColorArray(colors)
	
	var material = StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true
	#material.albedo_color = color
	$Mesh.mesh.surface_set_material(0, material)  
	$Mesh.mesh.add_surface_from_arrays($Mesh.mesh.PRIMITIVE_TRIANGLES, arrays)
	
	Global.node.game.add_child(self)


func set_color(color_) -> void:
	$Mesh.mesh.material.albedo_color = color_


func set_label(text_) -> void: 
	$LabelX.text = text_
	$LabelZ.text = text_


func init_mesh() -> void:
	$Mesh.mesh = MeshInstance3D.new()
	$Mesh.mesh = BoxMesh.new()
	$Mesh.mesh.size.y = 0.5
	
	var material = StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true
	$Mesh.mesh.surface_set_material(0, material)  
