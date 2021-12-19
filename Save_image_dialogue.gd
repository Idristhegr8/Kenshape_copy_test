extends Control

var current_sort: String = "Name"

var index_selected: int
var _files: Array = []
var path_extension: String = ".pt3d"
var path: String = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)
#var path: String = OS.get_system_dir(OS.SYSTEM_DIR_DCIM) + "/" + "Camera"

func _ready() -> void:

	if Global.drawing_board.y - 10 != 0:
# warning-ignore:narrowing_conversion
		var extra_y: int = Global.drawing_board.y-10
		for y in extra_y:
			rect_scale.y += 0.1
			rect_position.y -= 14.35

	if Global.drawing_board.x - 10 != 0:
# warning-ignore:narrowing_conversion
		var extra_x: int = Global.drawing_board.x-10
		for x in extra_x:
			rect_scale.x += 0.1
			rect_position.x -= 22.3

	var files: Array = []
	files = get_files(path)
#	files.sort()

	var dir: Directory = Directory.new()
	for file in files:
		$FilesAndFolders.add_item(file)
		if dir.dir_exists(path + "/" + file):
			$FilesAndFolders.set_item_icon(files.find(file), load("res://Folder.png"))
		else:
			$FilesAndFolders.set_item_icon(files.find(file), load("res://File.png"))

# warning-ignore:shadowed_variable
func get_files(path: String) -> Array:

	$FilesAndFolders.clear()

	var files: Array = []
	var dir: Directory = Directory.new()
# warning-ignore:return_value_discarded
	dir.open(path)
# warning-ignore:return_value_discarded
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	_files = files
	if current_sort == "Name":
		files.sort()
	else:
		files.sort_custom(self, "date_sort")
	return files

func _on_Cancel_Saving_pressed() -> void:
	queue_free()
	get_tree().paused = false
	get_parent().get_parent().get_node("Pixel").show()

func _on_Create_folder_pressed() -> void:

	if $Folder.text != "":
		var dir: Directory = Directory.new()
# warning-ignore:return_value_discarded
		dir.make_dir(path + "/" + $Folder.text)

		var files: Array = []
		files = get_files(path)
#		files.sort()

		for file in files:
			$FilesAndFolders.add_item(file)
			if dir.dir_exists(path + "/" + file):
				$FilesAndFolders.set_item_icon(files.find(file), load("res://Folder.png"))
			else:
				$FilesAndFolders.set_item_icon(files.find(file), load("res://File.png"))

func _on_Create_file_pressed() -> void:

	var file: File = File.new()
	if not file.file_exists(path + "/" + $File_name.text + path_extension):

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
			pixel_dat.depth_symmetry = pixel.depth_symmetry
			Global.pixels.append(pixel_dat)

		for pixel in Global.pixels:
			var pixel_dat: Array = [pixel.x, pixel.y, pixel.color.to_html(), pixel.depth, pixel.depth_symmetry]
			data.append(pixel_dat)

	# warning-ignore:return_value_discarded
		file.open_encrypted_with_pass(path + "/" + $File_name.text + path_extension, File.WRITE, get_parent().password)
		file.store_line(to_json(data))
		file.close()
	# warning-ignore:return_value_discarded
		file.open_encrypted_with_pass("user://" + $File_name.text + "_settings.pt3d", File.WRITE, get_parent().password)
		file.store_line(to_json(settings))
		file.close()

		queue_free()
		get_tree().paused = false
		get_parent().get_parent().get_node("Pixel").show()
	else:
		$File_exists_popup.show()

func _on_Cancel_pressed() -> void:
	$File_exists_popup.hide()

func _on_Overwrite_pressed() -> void:

	var file: File = File.new()

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
		pixel_dat.depth_symmetry = pixel.depth_symmetry
		Global.pixels.append(pixel_dat)

	for pixel in Global.pixels:
		var pixel_dat: Array = [pixel.x, pixel.y, pixel.color.to_html(), pixel.depth, pixel.depth_symmetry]
		data.append(pixel_dat)

# warning-ignore:return_value_discarded
	file.open_encrypted_with_pass(path + "/" + $File_name.text + path_extension, File.WRITE, get_parent().password)
	file.store_line(to_json(data))
	file.close()
# warning-ignore:return_value_discarded
	file.open_encrypted_with_pass("user://" + $File_name.text + "_settings.pt3d", File.WRITE, get_parent().password)
	file.store_line(to_json(settings))
	file.close()

	queue_free()
	get_tree().paused = false
	get_parent().get_parent().get_node("Pixel").show()

func _on_FilesAndFolders_item_activated(index: int) -> void:
	var dir: Directory = Directory.new()

	if dir.dir_exists(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) + "/" + _files[index]):
		var files: Array = []
		path = path + "/" + _files[index]
		files = get_files(path)
#		files.sort()

		for file in files:
			$FilesAndFolders.add_item(file)
			if dir.dir_exists(path + "/" + file):
				$FilesAndFolders.set_item_icon(files.find(file), load("res://Folder.png"))
			else:
				$FilesAndFolders.set_item_icon(files.find(file), load("res://File.png"))

func _on_FilesAndFolders_item_selected(index: int) -> void:
	var dir: Directory = Directory.new()
	if index_selected != index:
		index_selected = index
	elif dir.dir_exists(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) + "/" + _files[index]):
		var files: Array = []
		path = path + "/" + _files[index]
		files = get_files(path)
#		files.sort()

		for file in files:
			$FilesAndFolders.add_item(file)
			if dir.dir_exists(path + "/" + file):
				$FilesAndFolders.set_item_icon(files.find(file), load("res://Folder.png"))
			else:
				$FilesAndFolders.set_item_icon(files.find(file), load("res://File.png"))

func _on_Up_pressed() -> void:
	change_file()

func change_file():
	if path != OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS):
		var _path: Array = path.split("/")
		_path.remove(_path.size() - 1)
		var new_path: String = ""
		for path_ in _path:
			new_path += "/" + path_
		new_path.erase(0, 1)
		path = new_path
		var files: Array = []
		files = get_files(path)
#		files.sort()

		var dir: Directory = Directory.new()
		for file in files:
			$FilesAndFolders.add_item(file)
			if dir.dir_exists(path + "/" + file):
				$FilesAndFolders.set_item_icon(files.find(file), load("res://Folder.png"))
			else:
				$FilesAndFolders.set_item_icon(files.find(file), load("res://File.png"))

func _on_Name_pressed() -> void:
	current_sort = "Name"

	var files: Array = get_files(path)

	var dir: Directory = Directory.new()
	for file in files:
		$FilesAndFolders.add_item(file)
		if dir.dir_exists(path + "/" + file):
			$FilesAndFolders.set_item_icon(files.find(file), load("res://Folder.png"))
		else:
			$FilesAndFolders.set_item_icon(files.find(file), load("res://File.png"))

func _on_Date_pressed() -> void:
	current_sort = "Date"

	var files: Array = get_files(path)

	var dir: Directory = Directory.new()
	for file in files:
		$FilesAndFolders.add_item(file)
		if dir.dir_exists(path + "/" + file):
			$FilesAndFolders.set_item_icon(files.find(file), load("res://Folder.png"))
		else:
			$FilesAndFolders.set_item_icon(files.find(file), load("res://File.png"))

func date_sort(a, b) -> bool:
	var file: File = File.new()
	if file.get_modified_time(path + "/" + a) > file.get_modified_time(path + "/" + b):
		return true
	else:
		return false































