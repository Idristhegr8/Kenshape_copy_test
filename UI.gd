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


func _on_ColorPicker_color_changed(color: Color) -> void:
	_Color = color
