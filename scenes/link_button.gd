extends Control

var properties

func setup(prop):
	properties = prop
	
	$"LinkButton".text = properties[0]
	$"LinkButton".uri = properties[1]


func _on_remove_button_down():
	get_parent().get_parent().remove_link(properties)
	queue_free()
