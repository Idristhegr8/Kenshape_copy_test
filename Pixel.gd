extends Sprite

var depth: int = 1 setget set_depth
var grid_pos: Vector2
var color: Color

func _on_Depth_pressed() -> void:
	if get_tree().paused:
		if depth < 5:
			self.depth += 1
		else:
			self.depth = 1

func set_depth(value: int) -> void:
	depth = value
	$Depth.text = str(depth)

