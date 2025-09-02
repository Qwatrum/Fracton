extends Window

@onready var lines: Node2D = $"Line2D"
@onready var preview = $"ColorRect/Tips/Preview"

var pressed: bool = false
var current_line: Line2D = null

var widths = [1,3,7,9,14,21,42]
var colors = [Color.BLACK, Color.RED, Color.BLUE, Color.YELLOW, Color.GREEN, Color.WHITE, Color.SADDLE_BROWN, Color.ORANGE, Color.WEB_GRAY]
var width_i = 2
var color_i = 0

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

func _ready():
	dir_absolute(save_file_path)
	load_settings()
	
	always_on_top = settings[4]

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			pressed = event.pressed
			
			if pressed:
				current_line = Line2D.new()
				current_line.default_color = colors[color_i % len(colors)]
				current_line.width = widths[width_i % len(widths)]
				lines.add_child(current_line)
				current_line.add_point(event.position)
				
	elif event is InputEventMouseMotion and pressed:
		current_line.add_point(event.position)

func _process(_delta):
	
	if Input.is_action_just_pressed("ui_undo"):
		if len(lines.get_children()) != 0:
			var child = lines.get_children()[-1]
			child.queue_free()
	if Input.is_action_just_pressed("width"):
		width_i += 1
		update_preview()
	if Input.is_action_just_pressed("color"):
		color_i += 1
		update_preview()
	if Input.is_action_just_pressed("w_transparent"):
		transparent = not transparent
		transparent_bg = not transparent_bg
		if transparent:
			$"ColorRect".hide()
		else:
			$"ColorRect".show()

func update_preview():
	preview.default_color = colors[color_i % len(colors)]
	preview.width = widths[width_i % len(widths)]
	



func _on_close_requested():
	get_parent().closed("drawing")
	queue_free()
