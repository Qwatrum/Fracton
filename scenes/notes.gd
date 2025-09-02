extends Window

var notes
var settings
var save_file_path = "user://save"
var save_file_name = "DataSaver.tres"
var data = Data.new()
func dir_absolute(path):
	DirAccess.make_dir_absolute(path)
func load_all():
	if FileAccess.file_exists(save_file_path + save_file_name):
		data = ResourceLoader.load(save_file_path + save_file_name)
		settings = data.settings.duplicate()
		notes = data.notes
	else:
		data.settings = [false,false,false,false,false,false]
		data.notes = ""
		ResourceSaver.save(data, save_file_path + save_file_name)
		load_all()
func save_notes():
	data.notes = notes
	ResourceSaver.save(data, save_file_path + save_file_name)
func _ready():
	dir_absolute(save_file_path)
	load_all()
	
	$"TextEdit".text = notes
	


func _on_close_requested():
	notes = $"TextEdit".text
	save_notes()
	get_parent().closed("notes")
	queue_free()
