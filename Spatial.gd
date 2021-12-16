extends Spatial

var pixel_y: Array = []

func _ready() -> void:
	for pixel in Global.pixels:
#		if x_pixels.has(pixel.x/64):
#			add_b(-pixel.x, pixel.y)
#		else:
			add_b((pixel.x/64-((Global.drawing_board.x/2)+1))*64, (pixel.y/64-((Global.drawing_board.y/2)-1))*64, pixel.color, pixel.depth)

#		#symetry
#		add_b(-pixel.x, pixel.y)
#
#	#symetry 0x mesh
#
#	for pixel in Global.pixels:
#		if not pixel_y.has(pixel.y):
#			pixel_y.append(pixel.y)
#
#	for y_pixel in pixel_y:
#		var node: CSGMesh = load("res://CSGMesh.tscn").instance()
#		node.translation = Vector3(0, y_pixel/64, 0)
#		$Meshes.add_child(node)

func add_b(x: int, y: int, color: Color, depth: int) -> void:
	var node: CSGMesh = load("res://CSGMesh.tscn").instance()
# warning-ignore:integer_division
# warning-ignore:integer_division
	node.translation = Vector3(x/64, y/64, 0)
	var material: SpatialMaterial = SpatialMaterial.new()
	material.albedo_color = color
	node.set_material_override(material)
	$Meshes.add_child(node)

	if depth > 1:
# warning-ignore:integer_division
		if not depth %2:
			for num in depth-1:
				var d_node: CSGMesh = load("res://CSGMesh.tscn").instance()
				d_node.translation = Vector3(node.translation.x, node.translation.y, num + 1)
				d_node.set_material_override(material)
				$Meshes.add_child(d_node)
		else:
# warning-ignore:integer_division
			var n_depth: int = (depth-1)/2
			for num in n_depth:
				var d_node: CSGMesh = load("res://CSGMesh.tscn").instance()
				d_node.translation = Vector3(node.translation.x, node.translation.y, num + 1)
				d_node.set_material_override(material)
				$Meshes.add_child(d_node)
			for num in n_depth:
				var d_node: CSGMesh = load("res://CSGMesh.tscn").instance()
				d_node.translation = Vector3(node.translation.x, node.translation.y, -(num + 1))
				d_node.set_material_override(material)
				$Meshes.add_child(d_node)

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("B"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Drawing_board.tscn")

