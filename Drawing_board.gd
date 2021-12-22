extends Node2D

var undo_history: Array = []
var redo_history: Array = []
var temp_arr: Array = []

var max_zoom: Vector2

# warning-ignore:unused_signal
signal depth()
# warning-ignore:unused_signal
signal depth_symmetry()

enum{
	pencil,
	eraser,
	color_picker
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
#			$Camera2D.zoom.y += 0.1
			$UI/ColorPicker.rect_scale.y += 0.1
#			$UI/FileDialog.rect_scale.y += 0.1
			$UI/ColorPicker.rect_global_position.y -= 23.1

	if Global.drawing_board.x - 10 != 0:
# warning-ignore:narrowing_conversion
		var extra_x: int = Global.drawing_board.x-10
		for x in extra_x:
			$UI.rect_size.x += 64
#			$Camera2D.zoom.x += 0.1
			$UI/ColorPicker.rect_scale.x += 0.1
#			$UI/FileDialog.rect_scale.x += 0.1
			$UI/ColorPicker.rect_global_position.x -= 16.8

	if Global.pixels != []:
		for pixel in Global.pixels:
			var node: Sprite = load("res://Pixel.tscn").instance()
			node.global_position = Vector2(pixel.x, pixel.y)
			node.modulate = pixel.color
			node.depth = pixel.depth
			node.depth_symmetry = pixel.depth_symmetry
# warning-ignore:return_value_discarded
			connect("depth", node, "depth")
# warning-ignore:return_value_discarded
			connect("depth_symmetry", node, "depth_symmetry")
			$Pixels.add_child(node)

	if Global.drawing_board.x > 10:
		$BG.rect_size = Global.drawing_board

	$Camera2D.limit_bottom = Global.drawing_board.y*64+32
	$Camera2D.limit_right = Global.drawing_board.x*64+32
	if Global.drawing_board.x > Global.drawing_board.y:
		$Camera2D.zoom = Vector2(Global.drawing_board.y/10, Global.drawing_board.y/10)
		max_zoom = Vector2(Global.drawing_board.y/10, Global.drawing_board.y/10)
	else:
		max_zoom = Vector2(Global.drawing_board.x/10, Global.drawing_board.x/10)
		$Camera2D.zoom = Vector2(Global.drawing_board.x/10, Global.drawing_board.x/10)

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
		$Pixel.hide()
		$Pixel_outline.show()
		state = eraser
	if Input.is_action_just_pressed("P") and not is_saving:
		$Pixel.show()
		$Pixel_outline.hide()
		state = pencil
	if Input.is_action_just_pressed("O") and not is_saving:
		$Pixel.hide()
		$Pixel_outline.show()
		state = color_picker

	if Input.is_action_pressed("Command") and Input.is_action_just_pressed("Z"):
		undo()

	if Input.is_action_pressed("Command") and Input.is_action_just_pressed("Y"):
		redo()

	if Input.is_action_pressed("Q") and $Camera2D.zoom > Vector2(1, 1):
		$Camera2D.zoom -= Vector2(0.1, 0.1)
	elif Input.is_action_pressed("W") and $Camera2D.zoom < max_zoom:
		$Camera2D.zoom += Vector2(0.1, 0.1)

	if Input.is_action_pressed("ui_up"):
		$Camera2D.global_position.y -= 20
	if Input.is_action_pressed("ui_down"):
		$Camera2D.global_position.y += 20
	if Input.is_action_pressed("ui_right"):
		$Camera2D.global_position.x += 20
	if Input.is_action_pressed("ui_left"):
		$Camera2D.global_position.x -= 20

# warning-ignore:unused_argument
func _input(event: InputEvent) -> void:

	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_draw and state == pencil:
		add_p()

	elif Input.is_action_just_released("release"):
		yield(get_tree(), "idle_frame")

		var pixel_grp: PixelGroups = PixelGroups.new()
		for pixel in temp_arr:
			var wr = weakref(pixel)
			if wr.get_ref():
				pixel_grp.pixels.append(pixel)
		undo_history.append(pixel_grp)
		temp_arr.clear()

	if Input.is_mouse_button_pressed(BUTTON_LEFT) and state == eraser:
		for pixel in get_tree().get_nodes_in_group("Pixel"):
			if grid_pos == pixel.global_position:
				pixel.queue_free()
		for pixel_dat in Global.pixels:
			if Vector2(pixel_dat.x, pixel_dat.y) == grid_pos:
				Global.pixels.erase(pixel_dat)
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and state == color_picker:
		for pixel in $Pixels.get_children():
			if pixel.global_position == grid_pos:
				$UI._Color = pixel.modulate
				$Pixel.modulate = pixel.modulate

func add_p() -> void:
	var pixels: Array = get_tree().get_nodes_in_group("Pixel")
	for pixel in pixels:
		if pixel.global_position == grid_pos:
			pixel.queue_free()
	if not grid_pos.x > Global.drawing_board.x*64 and not grid_pos.y > Global.drawing_board.y*64 and not grid_pos.x < 64 and not grid_pos.y < 64:
		var node: Sprite = load("res://Pixel.tscn").instance()
		node.global_position = grid_pos
		node.modulate = $UI._Color
# warning-ignore:return_value_discarded
		connect("depth", node, "depth")
# warning-ignore:return_value_discarded
		connect("depth_symmetry", node, "depth_symmetry")
		$Pixels.add_child(node)
		temp_arr.append(node)

func set_draw(value: bool) -> void:
	can_draw = value
#	if can_draw:
#		$Pixel.modulate = "ffffff"
#	else:
#		$Pixel.modulate = "ff0000"

func undo() -> void:
	if undo_history.size() > 0:
		var pixel_grp: PixelGroups = undo_history[undo_history.size()-1]
		var n_pixel_grp: PixelGroups = PixelGroups.new()
		for pixel in pixel_grp.pixels:
			var pixel_dat: PixelData = PixelData.new()
			pixel_dat.x = pixel.global_position.x
			pixel_dat.y = pixel.global_position.y
			pixel_dat.color = pixel.modulate
			pixel_dat.depth = pixel.depth
			pixel_dat.depth_symmetry = pixel.depth_symmetry
			n_pixel_grp.pixels.append(pixel_dat)
		redo_history.append(n_pixel_grp)

		for pixel in pixel_grp.pixels:
			var wr = weakref(pixel)
			if wr.get_ref():
				pixel.queue_free()
		undo_history.pop_back()

func redo() -> void:
	if redo_history.size() > 0:
		var pixel_grp: PixelGroups = redo_history[redo_history.size()-1]
		for pixel in pixel_grp.pixels:
			var node: Sprite = load("res://Pixel.tscn").instance()
			node.global_position = Vector2(pixel.x, pixel.y)
			node.modulate = pixel.color
			node.depth = pixel.depth
			node.depth_symmetry = pixel.depth_symmetry
# warning-ignore:return_value_discarded
			connect("depth", node, "depth")
# warning-ignore:return_value_discarded
			connect("depth_symmetry", node, "depth_symmetry")
			$Pixels.add_child(node)
		redo_history.pop_back()















