extends Control

var current_sort: String = "Name"

var _files: Array = []
var index_selected: int = -1
var path: String = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)
var parent: Control

func _ready() -> void:

	var zoom: int = parent.get_parent().get_node("Camera2D").zoom.x
	for z in zoom:
		rect_scale.y += 0.1
		rect_position.y -= 14.35
		rect_scale.x += 0.1
		rect_position.x -= 22.3

#	if Global.drawing_board.y - 10 != 0:
## warning-ignore:narrowing_conversion
#		var extra_y: int = Global.drawing_board.y-10
#		for y in extra_y:
#			rect_scale.y += 0.1
#			rect_position.y -= 14.35
#
#	if Global.drawing_board.x - 10 != 0:
## warning-ignore:narrowing_conversion
#		var extra_x: int = Global.drawing_board.x-10
#		for x in extra_x:
#			rect_scale.x += 0.1
#			rect_position.x -= 22.3

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
	$Path.text = path
	if current_sort == "Name":
		files.sort()
	else:
		files.sort_custom(self, "date_sort")
	return files

#func _on_FilesAndFolders_item_activated(index: int) -> void:
#	var dir: Directory = Directory.new()
#
#	if dir.dir_exists(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) + "/" + _files[index]):
#		var files: Array = []
#		path = path + "/" + _files[index]
#		files = get_files(path)
##		files.sort()
#
#		for file in files:
#			$FilesAndFolders.add_item(file)
#			if dir.dir_exists(path + "/" + file):
#				$FilesAndFolders.set_item_icon(files.find(file), load("res://Folder.png"))
#			else:
#				$FilesAndFolders.set_item_icon(files.find(file), load("res://File.png"))

func _on_FilesAndFolders_item_activated(index: int) -> void:
	var dir: Directory = Directory.new()

	if dir.dir_exists(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) + "/" + _files[index]):
		var files: Array = []
		path = path + "/" + _files[index]
		files = get_files(path)
		files.sort()
		for file in files:
			$FilesAndFolders.add_item(file)

func _on_FilesAndFolders_item_selected(index: int) -> void:

	var dir: Directory = Directory.new()
	if index_selected != index:
		index_selected = index
	elif dir.dir_exists(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) + "/" + _files[index]):
		var files: Array = []
		path = path + "/" + _files[index]
		files = get_files(path)

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

func _on_Select_pressed() -> void:
	path = path + "/" + _files[index_selected]
	Global.file_name = _files[index_selected].trim_suffix(".pt3d")
	print(path)
	parent.Load(path)
	queue_free()
	get_tree().paused = false
	get_parent().get_parent().get_node("Pixel").show()

func _on_Cancel_Saving_pressed() -> void:
	queue_free()
	get_tree().paused = false
	get_parent().get_parent().get_node("Pixel").show()

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









