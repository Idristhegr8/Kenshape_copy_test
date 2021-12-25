extends Sprite

var depth: int = 1 setget set_depth
var grid_pos: Vector2
var color: Color
var depth_symmetry: bool = false setget set_depth_symmetry
var start_point: bool = false
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

func _ready() -> void:

	if start_point:
		pixel_grp.pixels.append(self)
		var directions: Array = [Vector2(64, 0), Vector2(-64, 0), Vector2(0, 64), Vector2(0, -64)]
		var queue: Array = []
		var checked: Array = []
		var pixels: Array = []
		queue.append(global_position)
		for pixel in get_parent().get_children():
			pixels.append(pixel.global_position)

		while queue.size() != 0:
			if not checked.has(queue[0]):
				var curr_pixel = queue[0]
				if not pixels.has(curr_pixel + directions[0]) and not (curr_pixel + directions[0]).x > Global.drawing_board.x*64 and not (curr_pixel + directions[0]).y > Global.drawing_board.y*64 and not (curr_pixel + directions[0]).x < 64 and not (curr_pixel + directions[0]).y < 64:
					add_pixel(curr_pixel + directions[0], modulate)
					queue.append(curr_pixel + directions[0])
					pixels.append(curr_pixel + directions[0])
#					have_to_fill.append(curr_pixel + directions[0])

				if not pixels.has(curr_pixel + directions[1]) and not (curr_pixel + directions[1]).x > Global.drawing_board.x*64 and not (curr_pixel + directions[1]).y > Global.drawing_board.y*64 and not (curr_pixel + directions[1]).x < 64 and not (curr_pixel + directions[1]).y < 64:
					add_pixel(curr_pixel + directions[1], modulate)
					queue.append(curr_pixel + directions[1])
					pixels.append(curr_pixel + directions[1])
#					queue.append(curr_pixel + directions[1])
#					have_to_fill.append(curr_pixel + directions[1])

				if not pixels.has(curr_pixel + directions[2]) and not (curr_pixel + directions[2]).x > Global.drawing_board.x*64 and not (curr_pixel + directions[2]).y > Global.drawing_board.y*64 and not (curr_pixel + directions[2]).x < 64 and not (curr_pixel + directions[2]).y < 64:
					add_pixel(curr_pixel + directions[2], modulate)
					queue.append(curr_pixel + directions[2])
					pixels.append(curr_pixel + directions[2])
#					queue.append(curr_pixel + directions[2])
#					have_to_fill.append(curr_pixel + directions[2])

				if not pixels.has(curr_pixel + directions[3]) and not (curr_pixel + directions[3]).x > Global.drawing_board.x*64 and not (curr_pixel + directions[3]).y > Global.drawing_board.y*64 and not (curr_pixel + directions[3]).x < 64 and not (curr_pixel + directions[3]).y < 64:
					add_pixel(curr_pixel + directions[3], modulate)
					queue.append(curr_pixel + directions[3])
					pixels.append(curr_pixel + directions[3])
#					queue.append(curr_pixel + directions[3])
#					have_to_fill.append(curr_pixel + directions[3])

				queue.pop_front()
				checked.append(curr_pixel)
			else:
				queue.pop_front()

		pixel_grp.state = "Pencil"
		get_parent().get_parent().undo_history.append(pixel_grp)

#		for pos in have_to_fill:
#			add_pixel(pos)

func add_pixel(pos: Vector2, color: Color) -> void:
	var pixel: Sprite = load("res://Pixel.tscn").instance()
	pixel.global_position = pos
	pixel.modulate = color
	get_parent().call_deferred("add_child", pixel)
	pixel_grp.pixels.append(pixel)




















