extends Control

var password: String = "its78652"
var mode: String = ""
var _Color: Color = Color("ffffff")

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("C") and not get_parent().is_saving:
		if $ColorPicker.visible and mode == "Color":
			$ColorPicker.hide()
			get_tree().paused = false
			get_parent().get_node("Pixel").modulate = _Color
			get_parent().get_node("Pixel").show()
		else:
			mode = "Color"
			get_parent().get_node("Pixel").hide()
			$ColorPicker.show()
			get_tree().paused = true

	

	if Input.is_action_just_pressed("D") and not get_parent().is_saving:
		if get_tree().paused and mode == "Depth":
			get_parent().emit_signal("depth", false)
			get_tree().paused = false
			get_parent().get_node("Pixel").show()
		else:
			mode = "Depth"
			get_parent().emit_signal("depth", true)
			get_tree().paused = true
			get_parent().get_node("Pixel").hide()

	if not Input.is_action_pressed("Command") and Input.is_action_just_pressed("S") and not get_parent().is_saving:
		if get_tree().paused and mode == "Symmetry":
			get_parent().emit_signal("depth_symmetry", false)
			get_tree().paused = false
			get_parent().get_node("Pixel").show()
		else:
			mode = "Symmetry"
			get_parent().emit_signal("depth_symmetry", true)
			get_tree().paused = true
			get_parent().get_node("Pixel").hide()

	if Input.is_action_pressed("Command") and Input.is_action_just_pressed("S"):
		if not get_tree().paused:
			var save_dialogue = load("res://Save_image_dialogue.tscn").instance()
#			add_child(save_dialogue)
			save_dialogue.parent = self
			get_parent().get_node("CanvasLayer").add_child(save_dialogue)
			get_parent().get_node("CanvasLayer").move_child(save_dialogue, 0)
			get_parent().is_saving = true
			get_tree().paused = true
			get_parent().get_node("Pixel").hide()

	if Input.is_action_pressed("Command") and Input.is_action_just_pressed("L") and not get_parent().is_saving:
		if not get_tree().paused:
			var save_dialogue = load("res://Select_file_dialogue.tscn").instance()
			save_dialogue.parent = self
			get_parent().get_node("CanvasLayer").add_child(save_dialogue)
			get_parent().get_node("CanvasLayer").move_child(save_dialogue, 0)
			get_tree().paused = true
			get_parent().get_node("Pixel").hide()

func _on_ColorPicker_color_changed(color: Color) -> void:
	_Color = color
	get_parent().get_node("CanvasLayer/Tools/C/ColorRect").color = color

func _on_P_pressed() -> void:
	get_parent().state = get_parent().pencil

func _on_E_pressed() -> void:
	get_parent().state = get_parent().eraser
	get_parent().get_node("Pixel").hide()
	get_parent().get_node("Pixel_outline").show()

func _on_B_pressed() -> void:
	get_parent().state = get_parent().bucket

func _on_O_pressed() -> void:
	get_parent().state = get_parent().color_picker

func _on_C_pressed() -> void:
	if $ColorPicker.visible and mode == "Color":
		$ColorPicker.hide()
		get_tree().paused = false
		get_parent().get_node("Pixel").modulate = _Color
		get_parent().get_node("Pixel").show()
	else:
		mode = "Color"
		get_parent().get_node("Pixel").hide()
		$ColorPicker.show()
		get_tree().paused = true

func _on_D_pressed() -> void:
	if get_tree().paused and mode == "Depth":
		get_parent().emit_signal("depth", false)
		get_tree().paused = false
		get_parent().get_node("Pixel").show()
	else:
		mode = "Depth"
		get_parent().emit_signal("depth", true)
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

func _on_LineEdit_text_changed(new_text: String) -> void:
	if int(new_text) <= 5:
		get_parent().depth = int(new_text)

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	get_parent().symmetry = button_pressed

func _on_Button_mouse_entered() -> void:
	get_parent().can_draw = false
	get_parent().get_node("Pixel").hide()

func _on_Button_mouse_exited() -> void:
	if not get_tree().paused:
		get_parent().can_draw = true
		get_parent().get_node("Pixel").show()

func Load(file_path: String) -> void:

	for pixel in get_parent().get_node("Pixels").get_children():
		pixel.queue_free()

	var data: Dictionary

	var ok: int = 1

	var file: File = File.new()
	if file_path.ends_with(".pt3d") and file.file_exists(file_path):
		if file.open_encrypted_with_pass(file_path, File.READ, password) == OK:
			ok = OK
			data = parse_json(file.get_line())
			file.close()
			Global.drawing_board.x = data.settings.x
			Global.drawing_board.y = data.settings.y
		else:
			$Error.dialog_text = "Error: Could Not Open The File!"
			$Error.popup_centered()
			print("Error: Could not open the File!")

	if ok == OK:
		Global.drawing_board.x = data.settings.x
		Global.drawing_board.y = data.settings.y
#	print(str(canvas_data))

	if ok == OK:
		for pixel in data.pixel_data:
			var node: Sprite = load("res://Pixel.tscn").instance()
			node.global_position = Vector2(pixel[0], pixel[1])
			node.modulate = pixel[2]
			node.depth = pixel[3]
			node.depth_symmetry = pixel[4]
	# warning-ignore:return_value_discarded
			get_parent().connect("depth", node, "depth")
	# warning-ignore:return_value_discarded
			get_parent().connect("depth_symmetry", node, "depth_symmetry")
			get_parent().get_node("Pixels").add_child(node)

		get_parent()._ready()

#	if Global.drawing_board.y - 10 != 0:
## warning-ignore:narrowing_conversion
#		var extra_y: int = Global.drawing_board.y-10
#		for y in extra_y:
#			rect_size.y += 64
#			get_parent().get_node("Camera2D").zoom.y += 0.1
#			$ColorPicker.rect_scale.y += 0.1
#			$ColorPicker.rect_global_position.y -= 23.1
#
#	if Global.drawing_board.x - 10 != 0:
#		get_parent().get_node("BG").rect_size = Global.drawing_board
## warning-ignore:narrowing_conversion
#		var extra_x: int = Global.drawing_board.x-10
#		for x in extra_x:
#			rect_size.x += 64
#			get_parent().get_node("Camera2D").zoom.x += 0.1
#			$ColorPicker.rect_scale.x += 0.1
#			$ColorPicker.rect_global_position.x -= 16.8























