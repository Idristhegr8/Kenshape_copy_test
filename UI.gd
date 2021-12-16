extends Control

var _Color: Color = Color("ffffff")

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("C"):
		if $ColorPicker.visible:
			$ColorPicker.hide()
			get_tree().paused = false
			get_parent().get_node("Pixel").modulate = _Color
			get_parent().get_node("Pixel").show()
		else:
			get_parent().get_node("Pixel").hide()
			$ColorPicker.show()
			get_tree().paused = true

	if Input.is_action_just_pressed("D"):
		if get_tree().paused:
			get_tree().paused = false
			get_parent().get_node("Pixel").show()
		else:
			get_tree().paused = true
			get_parent().get_node("Pixel").hide()

	if Input.is_action_pressed("Command") and Input.is_action_just_pressed("S"):
		if get_tree().paused:
			get_tree().paused = false
			get_parent().get_node("Pixel").show()
		else:
			$FileDialog.mode = FileDialog.MODE_SAVE_FILE
			$FileDialog.popup_centered()
			get_tree().paused = true
			get_parent().get_node("Pixel").hide()

	if Input.is_action_pressed("Command") and Input.is_action_just_pressed("L"):
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

func Save() -> void:

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
	if file.file_exists($FileDialog.current_path):
		pass
	else:
		file.open($FileDialog.current_path, File.WRITE)
		file.store_line(to_json(data))
		file.close()

func Load() -> void:

	var data: Array = []

	var file: File = File.new()
	if file.file_exists($FileDialog.current_path):
		file.open($FileDialog.current_path, File.READ)
		data = parse_json(file.get_line())
		file.close()

	for pixel in data:
		var node: Sprite = load("res://Pixel.tscn").instance()
		node.global_position = Vector2(pixel[0], pixel[1])
		node.modulate = pixel[2]
		node.depth = pixel[3]
		get_parent().get_node("Pixels").add_child(node)

	print(str(data))












