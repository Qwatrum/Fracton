extends Window


func _on_close_requested():
	get_parent().closed("close")
	queue_free()
	
	


func _on_close_pressed():
	get_tree().quit()


func _on_back_pressed():
	get_parent().closed("close")
	queue_free()
