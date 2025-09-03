extends Node

@onready var main_window: Window = get_window()
@onready var hint = $"Hint"

@onready var settings_window = preload("res://scenes/settings.tscn")
@onready var checklist_window = preload("res://scenes/checklist.tscn")
@onready var close_window = preload("res://scenes/close.tscn")
@onready var notes_window = preload("res://scenes/notes.tscn")
@onready var drawing_window = preload("res://scenes/drawing.tscn")
@onready var timer_window = preload("res://scenes/timer.tscn")
@onready var link_window = preload("res://scenes/link.tscn")
@onready var ai_window = preload("res://scenes/ai.tscn")

@onready var windows = {"settings":[settings_window,0],"checklist":[checklist_window,0],"close":[close_window,0],"notes":[notes_window,0],"drawing":[drawing_window,0],"clock":[timer_window,0],"link":[link_window,0],"ai":[ai_window,0]}

var moving: bool
var buttons_shown: bool
var loading: bool


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
	
	ProjectSettings.set_setting("display/window/per_pixel_transparency/allowed", true)
	main_window.title = "Fracton"
	main_window.borderless = false
	main_window.unresizable = true
	main_window.always_on_top = true
	main_window.gui_embed_subwindows = false
	main_window.transparent = true
	main_window.transparent_bg = true
	main_window.min_size = Vector2(256,256)
	main_window.size = main_window.min_size
	
	moving = true
	buttons_shown = false
	loading = false
	$"Background".hide()
	$"Buttons".hide()
	set_button_positions()
	
	if settings[0]:
		$"Hint".hide()
	
	
func _process(_delta):
	
	if Input.is_action_just_pressed("accept") and moving:
		main_window.borderless = true
		main_window.min_size = Vector2(165,165)
		main_window.size = main_window.min_size
		main_window.position.x += 49
		main_window.position.y += 78
		moving = false
		
		hint.hide()
	if Input.is_action_just_pressed("nope") and not moving:
		main_window.borderless = false
		main_window.min_size = Vector2(256,256)
		main_window.size = main_window.min_size
		main_window.position.x -= 49
		main_window.position.y -= 78
		moving = true
		$"Background".hide()
		$"Buttons".hide()
		reset_buttons()
		
	
	
func set_button_positions():
	var radius = 47
	var distance = radius + 1
	
	var i = 0
	for child in $"Buttons".get_children():
		var angle = deg_to_rad(i * 45)
		var pos = Vector2(cos(angle),sin(angle))*distance
		child.position = pos
		child.set_pos(pos)
		child.hide()
		i += 1

func _on_area_2d_mouse_entered():
	if not moving:
		$"Background".show()
	


func _on_area_2d_mouse_exited():
	$"Background".hide()



func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if not moving:
		
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if not buttons_shown:
				buttons_shown = true
				$"Buttons".show()
			elif buttons_shown:
				buttons_shown = false
				$"Buttons".hide()
			var i = 0
			for child in $"Buttons".get_children():
				if buttons_shown:
					child.reset()
					child.set_direction(i)
					i += 1
				else:
					child.reset()
				
func reset_buttons():
	for child in $"Buttons".get_children():
		child.reset()

func open(name):
	if windows[name][1] == 0:
		var child = windows[name][0].instantiate()
		add_child(child)
		windows[name][1] = 1
		
func closed(name):
	windows[name][1] = 0
