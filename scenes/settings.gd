extends Window

var settings
var save_file_path = "user://save"
var save_file_name = "DataSaver.tres"
var data = Data.new()
func dir_absolute(path):
	DirAccess.make_dir_absolute(path)
func load_settings():
	if FileAccess.file_exists(save_file_path + save_file_name):
		data = ResourceLoader.load(save_file_path + save_file_name)
		settings = data.settings.duplicate()
	else:
		data.settings = [false,false,false,false,false,false]
		ResourceSaver.save(data, save_file_path + save_file_name)
		load_settings()
func save_settings():
	data.settings = settings.duplicate()
	ResourceSaver.save(data, save_file_path + save_file_name)

func _ready():
	dir_absolute(save_file_path)
	load_settings()

	$"ScrollContainer/VBoxContainer/MoveHint".button_pressed = settings[0]
	var i = 1
	for child in $"ScrollContainer/VBoxContainer/HBoxContainer".get_children():
		child.button_pressed = settings[i]
		i+=1
	
func _on_close_requested():

	save_settings()
	queue_free()
	get_parent().closed("settings")



func _on_move_hint_toggled(toggled_on):
	settings[0] = toggled_on


func _on_ai_toggled(toggled_on):
	settings[1] = toggled_on


func _on_notes_toggled(toggled_on):
	settings[2] = toggled_on


func _on_timer_toggled(toggled_on):
	settings[3] = toggled_on


func _on_draw_toggled(toggled_on):
	settings[4] = toggled_on


func _on_todo_toggled(toggled_on):
	settings[5] = toggled_on


func _on_delete_pressed():
	data.delete_all()
	settings = [false,false,false,false,false,false]
	$"ScrollContainer/VBoxContainer/MoveHint".button_pressed = settings[0]
	var i = 1
	for child in $"ScrollContainer/VBoxContainer/HBoxContainer".get_children():
		child.button_pressed = settings[i]
		i+=1
