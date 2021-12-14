extends Sprite

var depth: int = 1
var grid_pos: Vector2
var color: Color

func _on_Depth_pressed() -> void:
	if get_tree().paused:
		if depth < 5:
			depth += 1
		else:
			depth = 1
		$Depth.text = str(depth)


