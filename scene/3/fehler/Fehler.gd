extends Node3D



func _ready() -> void:
	init_mesh()


func init_mesh() -> void:
	$Mesh.mesh = MeshInstance3D.new()
	$Mesh.mesh = BoxMesh.new()
	$Mesh.mesh.size.y = 0.5
	
	var material = StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true
	$Mesh.mesh.surface_set_material(0, material)  


func set_color(color_) -> void:
	$Mesh.mesh.material.albedo_color = color_


func set_label(text_) -> void: 
	$LabelX.text = text_
	$LabelZ.text = text_


func set_emlbem(data_) -> void:
	var path = "res://asset/png/emblem/"+data_.type+"/"+data_.subtype+"/"+data_.name+".png"
	var texture = load(path)
	$SpriteX.set_texture(texture)
	$SpriteZ.set_texture(texture)


