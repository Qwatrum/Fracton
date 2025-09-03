extends Window

@onready var linkbutton = preload("res://scenes/link_button.tscn")

var links
var save_file_path = "user://save"
var save_file_name = "DataSaver.tres"
var data = Data.new()
func dir_absolute(path):
	DirAccess.make_dir_absolute(path)
func load_links():
	if FileAccess.file_exists(save_file_path + save_file_name):
		data = ResourceLoader.load(save_file_path + save_file_name)
		links = data.links.duplicate()
	else:
		data.links = []
		ResourceSaver.save(data, save_file_path + save_file_name)
		load_links()
func save_links():
	data.links = links.duplicate()
	ResourceSaver.save(data, save_file_path + save_file_name)

func _ready():
	dir_absolute(save_file_path)
	load_links()
	update_links()
	$"Panel".hide()
	
func update_links():
	for c in $"VBoxContainer".get_children():
		c.queue_free()
	for link in links:
		var inste = linkbutton.instantiate()
		$"VBoxContainer".add_child(inste)
		inste.setup(link)

func remove_link(prop):
	links.erase(prop)
	update_links()
	

func _on_close_requested():
	save_links()
	get_parent().closed("link")
	queue_free()



func _on_nope_pressed():
	$"Panel".hide()


func _on_add_pressed():
	$"Panel".show()



func _on_create_pressed():
	var uri = $"Panel/URI".text.strip_edges()
	if uri != "":
		if not str(uri).begins_with("https://"):
			uri = "https://"+uri
		links.append([$"Panel/Txt".text, uri])
		update_links()
		$"Panel".hide()
		$"Panel/URI".text = ""
		$"Panel/Txt".text = ""
