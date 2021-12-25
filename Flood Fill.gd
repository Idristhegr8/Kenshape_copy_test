extends Sprite

export var start_point: bool = false

func _ready() -> void:
	if start_point:
		var start_pos: Vector2 = global_position
		var directions: Array = [Vector2(16, 0), Vector2(-16, 0), Vector2(0, 16), Vector2(0, -16)]
		var queue: Array = []
		var checked: Array = []
		var have_to_fill: Array = []
		var pixels: Array = []
		queue.append(global_position)
		for pixel in get_parent().get_children():
			if pixel != self:
				pixels.append(pixel.global_position)

		while queue.size() != 0:
			if not checked.has(queue[0]):
				var curr_pixel = queue[0]
				if not pixels.has(curr_pixel + directions[0]):
					add_pixel(curr_pixel + directions[0])
					queue.append(curr_pixel + directions[0])
#					have_to_fill.append(curr_pixel + directions[0])

				if not pixels.has(curr_pixel + directions[1]):
					add_pixel(curr_pixel + directions[1])
					queue.append(curr_pixel + directions[1])
#					queue.append(curr_pixel + directions[1])
#					have_to_fill.append(curr_pixel + directions[1])

				if not pixels.has(curr_pixel + directions[2]):
					add_pixel(curr_pixel + directions[2])
					queue.append(curr_pixel + directions[2])
#					queue.append(curr_pixel + directions[2])
#					have_to_fill.append(curr_pixel + directions[2])

				if not pixels.has(curr_pixel + directions[3]):
					add_pixel(curr_pixel + directions[3])
					queue.append(curr_pixel + directions[3])
#					queue.append(curr_pixel + directions[3])
#					have_to_fill.append(curr_pixel + directions[3])

				queue.pop_front()
				checked.append(curr_pixel)
			else:
				queue.pop_front()
		print("end")

#		for pos in have_to_fill:
#			add_pixel(pos)

func add_pixel(pos: Vector2) -> void:
	var pixel: Sprite = load("res://Pixel.tscn").instance()
	pixel.global_position = pos
	get_parent().call_deferred("add_child", pixel)
















