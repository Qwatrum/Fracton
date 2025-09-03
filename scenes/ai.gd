extends Window

@onready var chat_box = preload("res://scenes/chat_button.tscn")
@onready var user_text = preload("res://scenes/user_message_label.tscn")
@onready var bot_answer = preload("res://scenes/bot_answer_label.tscn")

@onready var scrollcontainer = $"ScrollContainer"

var response_loading: bool
var chat_boxes = []
var current_chat = []
var api_url = ""

var chats
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
		chats = data.chats.duplicate()
	else:
		data.settings = [false,false,false,false,false,false]
		data.chats = []
		ResourceSaver.save(data, save_file_path + save_file_name)
		load_all()
func save_chats():
	data.chats = chats.duplicate()
	ResourceSaver.save(data, save_file_path + save_file_name)

func _ready():
	dir_absolute(save_file_path)
	load_all()
	response_loading = false
	always_on_top = settings[1]
	
	update_chat_names()
	
	$"ChatName".text = ""
	$"Chat".hide()


func update_chat_names():
	for child in $"ScrollContainer/Chats".get_children():
		if not (child.name == "ChatsTitle" or child.name == "HSeparator" or child.name == "NewChat"):
			child.queue_free()
	chat_boxes.clear()
	
	for c in chats:
		var inste = chat_box.instantiate()
		$"ScrollContainer/Chats".add_child(inste)
		inste.setup(c)
	$"Panel".hide()

func remove_chat_messages():
	$"ChatName".text = ""
	for child in $"Chat/ScrollContainer/VBoxContainer".get_children():
		child.queue_free()

func open_chat(c):
	remove_chat_messages()
	current_chat = c
	$"ChatName".text = c[0]
	$"Panel".hide()
	for message in c[2]:
		if message.begins_with("USER:"):
			var inste = user_text.instantiate()
			$"Chat/ScrollContainer/VBoxContainer".add_child(inste)
			inste.text = str(message).split("SER:")[1]
		elif message.begins_with("BOT:"):
			var inste = bot_answer.instantiate()
			$"Chat/ScrollContainer/VBoxContainer".add_child(inste)
			inste.text = str(message).split("OT:")[1]
	$"Chat".show()
	
func add_message(text):
	$"Panel".hide()
	var inste = user_text.instantiate()
	$"Chat/ScrollContainer/VBoxContainer".add_child(inste)
	inste.text = text
	current_chat[2].append("USER: "+text)
	
	add_response()
	
func add_response():
	response_loading = true
	
	var messages = []
	messages.append({"role":"system", "content":current_chat[1]})
	for m in current_chat[2]:
		if m.begins_with("USER:"):
			messages.append({"role":"user","content":m.substr(5)})
		elif m.begins_with("BOT:"):
			messages.append({"role":"assistant","content":m.substr(4)})
		
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_bot_response)
	
	var headers = ["Content-Type: application/json"]
	var body = {"messages":messages}
	var json_body = JSON.stringify(body)
	
	var err = http_request.request(api_url,headers,HTTPClient.METHOD_POST,json_body)
	
	if err != OK:
		print("Error 1 with the API request.")
	

func _on_bot_response(result, response_code, headers,body):
	response_loading = false
	
	if response_code != 200:
		print("Error 2 with the API request.", response_code, body.get_string_from_utf8())
		return
	
	var response_text = body.get_string_from_utf8()
	var response_json = JSON.parse_string(response_text)
	
	if response_json == null:
		print("Error while parsing JSON", response_text)
		return
	
	var response = response_json.get("choices", [])[0].get("message", {}).get("content","")
	response = response.split("</think>")[1]
	var inste = bot_answer.instantiate()
	$"Chat/ScrollContainer/VBoxContainer".add_child(inste)
	inste.text = response
	
	current_chat[2].append("BOT: "+response)
	
	for c in chats.duplicate():
		if c[0] == current_chat[0] and c[1] == current_chat[1]:
			chats.erase(c)
			chats.push_front(current_chat)
	update_chat_names()

func remove_chat(chat):
	if chat == current_chat:
		remove_chat_messages()
		$"Chat/MessageEdit".text = ""
		$"Chat".hide()
	chats.erase(chat)
	update_chat_names()
	
	
func _on_close_requested():
	if not response_loading:
		save_chats()
		get_parent().closed("ai")
		queue_free()


func _on_new_chat_button_down():
	$"ChatName".text = ""
	$"Panel".show()


func _on_nope_button_down():
	$"Panel".hide()


func _on_create_button_down():
	remove_chat_messages()
	$"Panel".hide()
	var chat_name = $"Panel/Name".text.strip_edges()
	var system_p = $"Panel/SystemPrompt".text.strip_edges()
	$"Panel/SystemPrompt".text = ""
	$"Panel/Name".text = ""
	if chat_name != "":
		chats.push_front([chat_name,system_p, []])
	update_chat_names()
	open_chat(chats[0])


func _on_send_button_down():
	var text = $"Chat/MessageEdit".text.strip_edges()
	if text != "":
		add_message(text)
		$"Chat/MessageEdit".text = ""
		$"Chat/MessageEdit".grab_focus()
