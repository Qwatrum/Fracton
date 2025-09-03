extends Window

var timer_running: bool
var time_left

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
	
	always_on_top = settings[3]
	
	timer_running = false
	time_left = -1
	
	$"Current_Timer".hide()
	$"New_Timer".show()

func reset_edits():
	$"New_Timer/Hours".text = ""
	$"New_Timer/Minutes".text = ""
	$"New_Timer/Seconds".text = ""
	

func _on_close_requested():
	get_parent().closed("clock")
	queue_free()

func set_new_timer(sec):
	$"New_Timer".hide()
	$"Current_Timer".show()
	timer_running = true
	time_left = sec
	reset_edits()
	
	update_text()
	$"Timer".start()

func lineedit_valid(line_edit: LineEdit) -> bool:
	var text = line_edit.text.strip_edges()
	
	if text == "":
		line_edit.text = "0"
	
	if not text.is_valid_int():
		return false
	
	var val = int(text)
	
	return val >= 0 and val <= 59

func update_text():
	if time_left <= 0:
		$"Current_Timer/TimeLeft".text = "Time's up!"
		$"Current_Timer/Cancel".text = "OK"
		$"Timer".stop()
		$"AudioStreamPlayer".play()
	else:
		$"Current_Timer/TimeLeft".text = scnds_convert(time_left)
	
func scnds_convert(seconds):
	var hours = seconds / 3600
	var minutes = (seconds % 3600) / 60
	var sec = seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, sec]

func _on_cancel_button_down():
	time_left = -1
	timer_running = false
	$"New_Timer".show()
	$"Current_Timer".hide()
	$"AudioStreamPlayer".stop()
	$"Timer".stop()


func _on_start_button_down():
	
	lineedit_valid($"New_Timer/Minutes")
	lineedit_valid($"New_Timer/Seconds")
	lineedit_valid($"New_Timer/Hours")
	
	if lineedit_valid($"New_Timer/Minutes") and lineedit_valid($"New_Timer/Seconds") and lineedit_valid($"New_Timer/Hours"):
		
		var value_m = int($"New_Timer/Minutes".text) * 60
		var value_s = int($"New_Timer/Seconds".text)
		var value_h = int($"New_Timer/Hours".text) * 60 * 60
		var sum = value_m+value_s+value_h
		
		if sum > 0:
			set_new_timer(sum)


func _on_five_min_button_down():
	set_new_timer(5*60)


func _on_ten_min_button_down():
	set_new_timer(10*60)


func _on_fifteen_min_button_down():
	set_new_timer(15*60)


func _on_half_hour_button_down():
	set_new_timer(30*60)




func _on_timer_timeout():
	time_left -= 1
	update_text()
