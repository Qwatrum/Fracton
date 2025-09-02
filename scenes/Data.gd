extends Resource
class_name Data

@export var settings = [false,false,false,false,false,false]
@export var todos = []
@export var notes = ""

func delete_all():
	settings = [false,false,false,false,false,false]
	todos = []
	notes = ""
