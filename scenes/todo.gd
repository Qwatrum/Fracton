extends Window

@onready var todo_checkbox = preload("res://scenes/todo_check_box.tscn")

var settings
var todos
var save_file_path = "user://save"
var save_file_name = "DataSaver.tres"
var data = Data.new()
func dir_absolute(path):
	DirAccess.make_dir_absolute(path)
func load_all():
	if FileAccess.file_exists(save_file_path + save_file_name):
		data = ResourceLoader.load(save_file_path + save_file_name)
		settings = data.settings.duplicate()
		todos = data.todos.duplicate()
	else:
		data.settings = [false,false,false,false,false,false]
		data.todos = []
		ResourceSaver.save(data, save_file_path + save_file_name)
		load_all()
func save_todos():
	
	data.todos = todos.duplicate()
	ResourceSaver.save(data, save_file_path + save_file_name)
func _ready():
	dir_absolute(save_file_path)
	load_all()
	
	always_on_top = settings[5]
	#transparent_bg = true
	
	for e in todos:
		var new_checkbox = todo_checkbox.instantiate()
		$"ScrollContainer/VBoxContainer".add_child(new_checkbox)
		new_checkbox.text = e[0]


func _on_close_requested():
	for e in todos.duplicate():
		if e[1]:
			todos.erase(e)
	save_todos()
	queue_free()
	get_parent().closed("checklist")


func _on_add_pressed():
	var text = str($"AddNew".text).strip_edges()
	if text != "":
		$"AddNew".text = ""
		var new_checkbox = todo_checkbox.instantiate()
		$"ScrollContainer/VBoxContainer".add_child(new_checkbox)
		new_checkbox.text = text
		todos.append([text,false])

func toggled(txt,state):
	for e in todos:
		if e[0] == txt:
			e[1] = state
