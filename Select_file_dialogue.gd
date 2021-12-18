extends Control

var file_path: String
var _files: Array = []
var index_selected: int
var path: String = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)
var parent: Control

func _ready() -> void:
	parent = get_parent()
	var files: Array = []
	files = get_files(path)
	files.sort()

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
		else: #elif file.begins_with(".") or file.ends_with(".jpg") or file.ends_with(".png"):
			files.append(file)
	dir.list_dir_end()
	_files = files
	$Path.text = path
	return files

func _on_FilesAndFolders_item_activated(index: int) -> void:
	var dir: Directory = Directory.new()

	if dir.dir_exists(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) + "/" + _files[index]):
		var files: Array = []
		path = path + "/" + _files[index]
		files = get_files(path)
		files.sort()

		for file in files:
			$FilesAndFolders.add_item(file)
			if dir.dir_exists(path + "/" + file):
				$FilesAndFolders.set_item_icon(files.find(file), load("res://Folder.png"))
			else:
				$FilesAndFolders.set_item_icon(files.find(file), load("res://File.png"))

func _on_FilesAndFolders_item_selected(index: int) -> void:
	file_path = path + "/" + _files[index]
	$Path.text = file_path

	var dir: Directory = Directory.new()
	if index_selected != index:
		index_selected = index
	elif dir.dir_exists(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) + "/" + _files[index]):
		var files: Array = []
		path = path + "/" + _files[index]
		files = get_files(path)
		files.sort()

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
		files.sort()

		var dir: Directory = Directory.new()
		for file in files:
			$FilesAndFolders.add_item(file)
			if dir.dir_exists(path + "/" + file):
				$FilesAndFolders.set_item_icon(files.find(file), load("res://Folder.png"))
			else:
				$FilesAndFolders.set_item_icon(files.find(file), load("res://File.png"))

func _on_Select_pressed() -> void:
	var files: Array = file_path.split("/")
	parent.Load(file_path, files[files.size()-1])
	queue_free()
	get_tree().paused = false
	get_parent().get_parent().get_node("Pixel").show()

func _on_Cancel_Saving_pressed() -> void:
	queue_free()
	get_tree().paused = false
	get_parent().get_parent().get_node("Pixel").show()










