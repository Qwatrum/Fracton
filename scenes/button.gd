extends Node2D

@export var image_name = ""
var posi: Vector2
var tween

func _ready():
	var texture = load("res://assets/"+image_name+".png")
	$"Normal".texture = texture
	var texture2 = load("res://assets/"+image_name+"_h.png")
	$"Hover".texture = texture2
	
	$"Hover".hide()
	hide()
	
	
func set_pos(pos):
	posi = pos
func reset():
	position = posi
	hide()

func set_direction(index):
	var duration = 0.1
	await get_tree().create_timer(duration * index).timeout
	show()

	var direction = deg_to_rad(45 * index)
	var offset = Vector2(cos(direction), sin(direction)) * 17
	var target_pos = position + offset
	
	tween = create_tween()
	tween.tween_property(self, "position", target_pos, duration)
	


func _on_area_2d_mouse_entered():
	$"Hover".show()
	$"Normal".hide()


func _on_area_2d_mouse_exited():
	$"Normal".show()
	$"Hover".hide()


func _on_area_2d_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
