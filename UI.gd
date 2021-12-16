extends Control

var _Color: Color = Color("ffffff")

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("C") and not get_parent().is_saving:
		if $ColorPicker.visible:
			$ColorPicker.hide()
			get_tree().paused = false
			get_parent().get_node("Pixel").modulate = _Color
			get_parent().get_node("Pixel").show()
		else:
			get_parent().get_node("Pixel").hide()
			$ColorPicker.show()
			get_tree().paused = true

	if Input.is_action_just_pressed("D") and not get_parent().is_saving:
		if get_tree().paused:
			get_tree().paused = false
			get_parent().get_node("Pixel").show()
		else:
			get_tree().paused = true
			get_parent().get_node("Pixel").hide()

	if Input.is_action_pressed("Command") and Input.is_action_just_pressed("S"):
		if get_tree().paused:
			get_parent().is_saving = false
			get_tree().paused = false
			get_parent().get_node("Pixel").show()
		else:
			get_parent().is_saving = true
			$FileDialog.mode = FileDialog.MODE_SAVE_FILE
			$FileDialog.popup_centered()
			get_tree().paused = true
			get_parent().get_node("Pixel").hide()

	if Input.is_action_pressed("Command") and Input.is_action_just_pressed("L") and not get_parent().is_saving:
		if get_tree().paused:
			get_tree().paused = false
			get_parent().get_node("Pixel").show()
		else:
			$FileDialog.mode = FileDialog.MODE_OPEN_FILE
			$FileDialog.popup_centered()
			get_tree().paused = true
			get_parent().get_node("Pixel").hide()

func _on_ColorPicker_color_changed(color: Color) -> void:
	_Color = color

func _on_P_pressed() -> void:
	get_parent().state = get_parent().pencil

func _on_E_pressed() -> void:
	get_parent().state = get_parent().eraser

func _on_C_pressed() -> void:
	if $ColorPicker.visible:
		$ColorPicker.hide()
		get_tree().paused = false
		get_parent().get_node("Pixel").modulate = _Color
		get_parent().get_node("Pixel").show()
	else:
		get_parent().get_node("Pixel").hide()
		$ColorPicker.show()
		get_tree().paused = true

func _on_D_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
		get_parent().get_node("Pixel").show()
	else:
		get_tree().paused = true
		get_parent().get_node("Pixel").hide()

func _on_3D_pressed() -> void:
	if not get_tree().paused:
		for pixel in get_tree().get_nodes_in_group("Pixel"):

			var pixel_dat: PixelData = PixelData.new()
			pixel_dat.x = pixel.global_position.x
			pixel_dat.y = pixel.global_position.y
			pixel_dat.color = pixel.modulate
			pixel_dat.depth = pixel.depth
			Global.pixels.append(pixel_dat)

	# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Spatial.tscn")

func _on_Button_mouse_entered() -> void:
	get_parent().can_draw = false
	get_parent().get_node("Pixel").hide()

func _on_Button_mouse_exited() -> void:
	get_parent().can_draw = true
	get_parent().get_node("Pixel").show()

func _on_FileDialog_confirmed() -> void:
	if $FileDialog.mode == FileDialog.MODE_SAVE_FILE:
		Save()
	else:
		Load()
	get_parent().is_saving = false
	get_tree().paused = false
	get_parent().get_node("Pixel").show()

func Save() -> void:

	var settings: Dictionary = {
		x = Global.drawing_board.x,
		y = Global.drawing_board.y
	}

	var data: Array = []

	Global.pixels.clear()
	for pixel in get_tree().get_nodes_in_group("Pixel"):
		var pixel_dat: PixelData = PixelData.new()
		pixel_dat.x = pixel.global_position.x
		pixel_dat.y = pixel.global_position.y
		pixel_dat.color = pixel.modulate
		pixel_dat.depth = pixel.depth
		Global.pixels.append(pixel_dat)

	for pixel in Global.pixels:
		var pixel_dat: Array = [pixel.x, pixel.y, pixel.color.to_html(), pixel.depth]
		data.append(pixel_dat)

	var file: File = File.new()
	file.open($FileDialog.current_path + ".pt3d", File.WRITE)
	file.store_line(to_json(data))
	file.close()
	file.open($FileDialog.current_path + "_settings.pt3d", File.WRITE)
	file.store_line(to_json(settings))
	file.close()

func Load() -> void:

	for pixel in get_parent().get_node("Pixels").get_children():
		pixel.queue_free()

	var settings: Dictionary = {}

	var data: Array

	var file: File = File.new()
	if $FileDialog.current_path.ends_with(".pt3d") and file.file_exists($FileDialog.current_path):
		file.open($FileDialog.current_path, File.READ)
		data = parse_json(file.get_line())
		file.close()

	var settings_file: File = File.new()
	var path: String = $FileDialog.current_path.trim_suffix(".pt3d") + "_settings.pt3d"
	if $FileDialog.current_path.ends_with(".pt3d") and settings_file.file_exists(path):
		settings_file.open(path, File.READ)
		settings = parse_json(settings_file.get_line())
		settings_file.close()
#	print(str(canvas_data))

	Global.drawing_board.x = settings.x
	Global.drawing_board.y = settings.y

	for pixel in data:
		var node: Sprite = load("res://Pixel.tscn").instance()
		node.global_position = Vector2(pixel[0], pixel[1])
		node.modulate = pixel[2]
		node.depth = pixel[3]
		get_parent().get_node("Pixels").add_child(node)

	if Global.drawing_board.y - 10 != 0:
# warning-ignore:narrowing_conversion
		var extra_y: int = Global.drawing_board.y-10
		for y in extra_y:
			rect_size.y += 64
			get_parent().get_node("Camera2D").zoom.y += 0.1
			$ColorPicker.rect_scale.y += 0.1
			$FileDialog.rect_scale.y += 0.1
			$ColorPicker.rect_global_position.y -= 23.1

	if Global.drawing_board.x - 10 != 0:
		get_parent().get_node("BG").rect_size = Global.drawing_board
# warning-ignore:narrowing_conversion
		var extra_x: int = Global.drawing_board.x-10
		for x in extra_x:
			rect_size.x += 64
			get_parent().get_node("Camera2D").zoom.x += 0.1
			$ColorPicker.rect_scale.x += 0.1
			$FileDialog.rect_scale.x += 0.1
			$ColorPicker.rect_global_position.x -= 16.8








