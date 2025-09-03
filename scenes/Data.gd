extends Resource
class_name Data

@export var settings = [false,false,false,false,false,false]
@export var todos = []
@export var notes = ""
@export var links = []
@export var chats = []

func delete_all():
	settings = [false,false,false,false,false,false]
	todos = []
	notes = ""
	links = []
	chats = []
