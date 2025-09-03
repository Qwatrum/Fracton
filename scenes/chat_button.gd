extends Button

var properties

func setup(p):
	properties = p
	text = properties[0]


func _on_button_down():
	get_parent().get_parent().get_parent().open_chat(properties)


func _on_button_button_down():
	get_parent().get_parent().get_parent().remove_chat(properties)
