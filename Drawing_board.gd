extends Node2D

enum{
	pencil,
	eraser
}

var state = pencil

var grid_pos: Vector2
var can_draw: bool = true setget set_draw

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	$Pixel.global_position = mouse_pos.snapped(Vector2(64, 64))
	grid_pos = mouse_pos.snapped(Vector2(64, 64))

	if Input.is_action_just_pressed("ui_accept"):
		for pixel in get_tree().get_nodes_in_group("Pixel"):

			var pixel_dat: PixelData = PixelData.new()
			pixel_dat.x = pixel.global_position.x
			pixel_dat.y = pixel.global_position.y
			pixel_dat.color = pixel.modulate
			pixel_dat.depth = pixel.depth
			Global.pixels.append(pixel_dat)

		get_tree().change_scene("res://Spatial.tscn")
	if Input.is_action_just_pressed("E"):
		state = eraser
	if Input.is_action_just_pressed("P"):
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
	var node: Sprite = load("res://Pixel.tscn").instance()
	node.global_position = grid_pos
	node.modulate = $UI._Color
	$Pixels.add_child(node)

func _on_Area2D_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Pixel"):
		self.can_draw = true

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Pixel"):
		self.can_draw = false

func set_draw(value: bool) -> void:
	can_draw = value
#	if can_draw:
#		$Pixel.modulate = "ffffff"
#	else:
#		$Pixel.modulate = "ff0000"










