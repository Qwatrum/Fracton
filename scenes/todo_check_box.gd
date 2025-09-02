extends CheckBox


func _on_toggled(toggled_on):
	get_parent().get_parent().get_parent().toggled(text,toggled_on)
