extends Node

@onready var main_window: Window = get_window()
@onready var hint = $"Hint"
var moving: bool
var buttons_shown: bool
var loading: bool

func _ready():
	
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
	
	
func _process(_delta):
	
	if Input.is_action_just_pressed("accept") and moving:
		main_window.borderless = true
		main_window.min_size = Vector2(165,165)
		main_window.size = main_window.min_size
		main_window.position.x += 49 #64
		main_window.position.y += 78 #100
		moving = false
		print(main_window.position)
		
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
		
		
	if Input.is_action_just_pressed("ui_left"):
		main_window.position.x -= 5
	if Input.is_action_just_pressed("ui_right"):
		main_window.position.x += 5
	if Input.is_action_just_pressed("ui_up"):
		main_window.position.y -= 5
	if Input.is_action_just_pressed("ui_down"):
		main_window.position.y += 5
		
	
	'''
	<a href="https://www.flaticon.com/free-icons/chatbot" title="chatbot icons">Chatbot icons created by LAFS - Flaticon</a>
	<a href="https://www.flaticon.com/free-icons/essay" title="essay icons">Essay icons created by RIkas Dzihab - Flaticon</a>
	<a href="https://www.flaticon.com/free-icons/clock" title="clock icons">Clock icons created by Ilham Fitrotul Hayat - Flaticon</a>
	<a href="https://www.flaticon.com/free-icons/github" title="github icons">Github icons created by Pixel perfect - Flaticon</a>
	<a href="https://www.flaticon.com/free-icons/draw" title="draw icons">Draw icons created by Freepik - Flaticon</a>
	<a href="https://www.flaticon.com/free-icons/tasks" title="tasks icons">Tasks icons created by Graphics Plazza - Flaticon</a>
	<a href="https://www.flaticon.com/free-icons/link" title="link icons">Link icons created by Creaticca Creative Agency - Flaticon</a>
	<a href="https://www.flaticon.com/free-icons/settings" title="settings icons">Settings icons created by Pixel perfect - Flaticon</a>
	'''
	
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
