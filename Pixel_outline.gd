extends Sprite

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = mouse_pos.snapped(Vector2(64, 64))
