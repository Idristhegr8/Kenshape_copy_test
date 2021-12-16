extends Control



func _on_New_pressed() -> void:
	if $Canvas_size.text.is_valid_integer():
		Global.drawing_board = Vector2(int($Canvas_size.text), int($Canvas_size.text))
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Drawing_board.tscn")
