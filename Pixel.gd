extends Sprite

var depth: int = 1 setget set_depth
var grid_pos: Vector2
var color: Color
var depth_symmetry: bool = false setget set_depth_symmetry
var start_point: bool = false
var color_to_fill
var pixel_grp: PixelGroups = PixelGroups.new()

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
#	print(str(depth_symmetry))

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

func _ready() -> void:

	if start_point:
		pixel_grp.pixels.append(self)
		var directions: Array = [Vector2(64, 0), Vector2(-64, 0), Vector2(0, 64), Vector2(0, -64)]
		var queue: Array = []
		var checked: Array = []
		var pixels: Array = []
		var all_pixels: Array = []
		queue.append(self)
		for pixel in get_parent().get_children():
			all_pixels.append(pixel)
			pixels.append(pixel.global_position)

		while queue.size() != 0:
			if not checked.has(queue[0]):
				var curr_pixel: Sprite = queue[0]

				if not pixels.has(curr_pixel.global_position + directions[0]) and not (curr_pixel.global_position + directions[0]).x > Global.drawing_board.x*64 and not (curr_pixel.global_position + directions[0]).y > Global.drawing_board.y*64 and not (curr_pixel.global_position + directions[0]).x < 64 and not (curr_pixel.global_position + directions[0]).y < 64:
					var pixel: Sprite = add_pixel(curr_pixel.global_position + directions[0], modulate)
					queue.append(pixel)
					pixels.append(curr_pixel.global_position + directions[0])
					all_pixels.append(pixel)
				elif color_to_fill != null and all_pixels[pixels.find(curr_pixel.global_position + directions[0])].modulate == color_to_fill and pixels.has(curr_pixel.global_position + directions[0]):
					var p = all_pixels[pixels.find(curr_pixel.global_position + directions[0])]
					p.modulate = modulate
					p.depth = depth
					p.depth_symmetry = depth_symmetry
					queue.append(p)
					pixels.append(curr_pixel.global_position + directions[0])
					all_pixels.append(p)
					pixel_grp.pixels.append(p.global_position)

				if not pixels.has(curr_pixel.global_position + directions[1]) and not (curr_pixel.global_position + directions[1]).x > Global.drawing_board.x*64 and not (curr_pixel.global_position + directions[1]).y > Global.drawing_board.y*64 and not (curr_pixel.global_position + directions[1]).x < 64 and not (curr_pixel.global_position + directions[1]).y < 64:
					var pixel: Sprite = add_pixel(curr_pixel.global_position + directions[1], modulate)
					queue.append(pixel)
					pixels.append(curr_pixel.global_position + directions[1])
					all_pixels.append(pixel)
				elif color_to_fill != null and all_pixels[pixels.find(curr_pixel.global_position + directions[1])].modulate == color_to_fill and pixels.has(curr_pixel.global_position + directions[1]):
					var p = all_pixels[pixels.find(curr_pixel.global_position + directions[1])]
					p.modulate = modulate
					p.depth = depth
					p.depth_symmetry = depth_symmetry
					queue.append(p)
					pixels.append(curr_pixel.global_position + directions[1])
					all_pixels.append(p)
					pixel_grp.pixels.append(p.global_position)
#					all_pixels[pixels.find(curr_pixel.global_position + directions[1])].queue_free()
#					var pixel: Sprite = add_pixel(curr_pixel.global_position + directions[1], modulate)
#					queue.append(pixel)
#					pixels.append(curr_pixel.global_position + directions[1])
#					all_pixels.append(pixel)
#					have_to_fill.append(curr_pixel.global_position + directions[1])

				if not pixels.has(curr_pixel.global_position + directions[2]) and not (curr_pixel.global_position + directions[2]).x > Global.drawing_board.x*64 and not (curr_pixel.global_position + directions[2]).y > Global.drawing_board.y*64 and not (curr_pixel.global_position + directions[2]).x < 64 and not (curr_pixel.global_position + directions[2]).y < 64:
					var pixel: Sprite = add_pixel(curr_pixel.global_position + directions[2], modulate)
					queue.append(pixel)
					pixels.append(curr_pixel.global_position + directions[2])
					all_pixels.append(pixel)
				elif pixels.has(curr_pixel.global_position + directions[2]) and all_pixels[pixels.find(curr_pixel.global_position + directions[2])].modulate == color_to_fill:
					var p = all_pixels[pixels.find(curr_pixel.global_position + directions[2])]
					p.modulate = modulate
					p.depth = depth
					p.depth_symmetry = depth_symmetry
					queue.append(p)
					pixels.append(curr_pixel.global_position + directions[2])
					all_pixels.append(p)
					pixel_grp.pixels.append(p.global_position)

				if not pixels.has(curr_pixel.global_position + directions[3]) and not (curr_pixel.global_position + directions[3]).x > Global.drawing_board.x*64 and not (curr_pixel.global_position + directions[3]).y > Global.drawing_board.y*64 and not (curr_pixel.global_position + directions[3]).x < 64 and not (curr_pixel.global_position + directions[3]).y < 64:
					var pixel: Sprite = add_pixel(curr_pixel.global_position + directions[3], modulate)
					queue.append(pixel)
					pixels.append(curr_pixel.global_position + directions[3])
					all_pixels.append(pixel)
				elif pixels.has(curr_pixel.global_position + directions[3]) and all_pixels[pixels.find(curr_pixel.global_position + directions[3])].modulate == color_to_fill:
					var p = all_pixels[pixels.find(curr_pixel.global_position + directions[3])]
					p.modulate = modulate
					p.depth = depth
					p.depth_symmetry = depth_symmetry
					queue.append(p)
					pixels.append(curr_pixel.global_position + directions[3])
					all_pixels.append(p)
					pixel_grp.pixels.append(p.global_position)
#					all_pixels[pixels.find(curr_pixel.global_position + directions[3])].queue_free()
#					var pixel: Sprite = add_pixel(curr_pixel.global_position + directions[3], modulate)
#					queue.append(pixel)
#					pixels.append(curr_pixel.global_position + directions[3])
#					all_pixels.append(pixel)
#					have_to_fill.append(curr_pixel.global_position + directions[3])

				queue.pop_front()
				checked.append(curr_pixel)
			else:
				queue.pop_front()

		pixel_grp.state = "Fill"
		pixel_grp.last_color = color_to_fill
		get_parent().get_parent().undo_history.append(pixel_grp)

func add_pixel(pos: Vector2, _color: Color) -> Node2D:
	var pixel: Sprite = load("res://Pixel.tscn").instance()
	pixel.global_position = pos
	pixel.modulate = _color
	pixel.depth = depth
	pixel.depth_symmetry = depth_symmetry
# warning-ignore:return_value_discarded
	get_parent().get_parent().connect("depth", pixel, "depth")
# warning-ignore:return_value_discarded
	get_parent().get_parent().connect("depth_symmetry", pixel, "depth_symmetry")
	get_parent().add_child(pixel)
	pixel_grp.pixels.append(pixel)
	return pixel




















