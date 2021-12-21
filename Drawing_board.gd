extends Node2D

# warning-ignore:unused_signal
signal depth()
# warning-ignore:unused_signal
signal depth_symmetry()

enum{
	pencil,
	eraser
}

var state = pencil

var grid_pos: Vector2
var can_draw: bool = true setget set_draw
var is_saving: bool = false

func _ready() -> void:

	if Global.drawing_board.y - 10 != 0:
# warning-ignore:narrowing_conversion
		var extra_y: int = Global.drawing_board.y-10
		for y in extra_y:
			$UI.rect_size.y += 64
			$Camera2D.zoom.y += 0.1
			$UI/ColorPicker.rect_scale.y += 0.1
#			$UI/FileDialog.rect_scale.y += 0.1
			$UI/ColorPicker.rect_global_position.y -= 23.1

	if Global.drawing_board.x - 10 != 0:
# warning-ignore:narrowing_conversion
		var extra_x: int = Global.drawing_board.x-10
		for x in extra_x:
			$UI.rect_size.x += 64
			$Camera2D.zoom.x += 0.1
			$UI/ColorPicker.rect_scale.x += 0.1
#			$UI/FileDialog.rect_scale.x += 0.1
			$UI/ColorPicker.rect_global_position.x -= 16.8

	if Global.pixels != []:
		for pixel in Global.pixels:
			var node: Sprite = load("res://Pixel.tscn").instance()
			node.global_position = Vector2(pixel.x, pixel.y)
			node.modulate = pixel.color
			node.depth = pixel.depth
# warning-ignore:return_value_discarded
			connect("depth", node, "depth")
# warning-ignore:return_value_discarded
			connect("depth_symmetry", node, "depth_symmetry")
			$Pixels.add_child(node)

	if Global.drawing_board.x > 10:
		$BG.rect_size = Global.drawing_board


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	$Pixel.global_position = mouse_pos.snapped(Vector2(64, 64))
	grid_pos = mouse_pos.snapped(Vector2(64, 64))

	if Input.is_action_just_pressed("ui_accept") and not is_saving:
		Global.pixels.clear()
		for pixel in get_tree().get_nodes_in_group("Pixel"):

			var pixel_dat: PixelData = PixelData.new()
			pixel_dat.x = pixel.global_position.x
			pixel_dat.y = pixel.global_position.y
			pixel_dat.color = pixel.modulate
			pixel_dat.depth = pixel.depth
			pixel_dat.depth_symmetry = pixel.depth_symmetry
			Global.pixels.append(pixel_dat)

# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Spatial.tscn")
	if Input.is_action_just_pressed("E") and not is_saving:
		state = eraser
	if Input.is_action_just_pressed("P") and not is_saving:
		state = pencil

# warning-ignore:unused_argument
func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_draw and state == pencil:
		add_p()
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and state == eraser:
		for pixel in get_tree().get_nodes_in_group("Pixel"):
			if grid_pos == pixel.global_position:
				pixel.queue_free()
		for pixel_dat in Global.pixels:
			if Vector2(pixel_dat.x, pixel_dat.y) == grid_pos:
				Global.pixels.erase(pixel_dat)

func add_p() -> void:
	var pixels: Array = get_tree().get_nodes_in_group("Pixel")
	for pixel in pixels:
		if pixel.global_position == grid_pos:
			pixel.queue_free()
	if not grid_pos.x > Global.drawing_board.x*64 and not grid_pos.y > Global.drawing_board.y*64 and not grid_pos.x < 0 and not grid_pos.y < 0:
		var node: Sprite = load("res://Pixel.tscn").instance()
		node.global_position = grid_pos
		node.modulate = $UI._Color
# warning-ignore:return_value_discarded
		connect("depth", node, "depth")
# warning-ignore:return_value_discarded
		connect("depth_symmetry", node, "depth_symmetry")
		$Pixels.add_child(node)

func set_draw(value: bool) -> void:
	can_draw = value
#	if can_draw:
#		$Pixel.modulate = "ffffff"
#	else:
#		$Pixel.modulate = "ff0000"



















