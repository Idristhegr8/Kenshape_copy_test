extends Sprite

var depth: int = 1 setget set_depth
var grid_pos: Vector2
var color: Color
var depth_symmetry: bool = false setget set_depth_symmetry

func _on_Depth_pressed() -> void:
	if get_tree().paused:
		if depth < 5:
			self.depth += 1
		else:
			self.depth = 1

func set_depth(value: int) -> void:
	depth = value
	$Depth.text = str(depth)

func set_depth_symmetry(value: bool) -> void:
	depth_symmetry = value
	if not depth_symmetry:
		$Depth_symmetry.text = " f"
	else:
		$Depth_symmetry.text = " t"

func _on_Depth_symmetry_pressed() -> void:
	if depth_symmetry:
		self.depth_symmetry = false
	else:
		self.depth_symmetry = true
	print(str(depth_symmetry))

# warning-ignore:function_conflicts_variable
func depth(value: bool) -> void:
	if value:
		$Depth.show()
	else:
		$Depth.hide()

# warning-ignore:function_conflicts_variable
func depth_symmetry(value: bool) -> void:
	if value:
		$Depth_symmetry.show()
	else:
		$Depth_symmetry.hide()




