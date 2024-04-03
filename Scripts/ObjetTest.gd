extends Area2D

var selected = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func followMouse() :
	print(position)
	print(get_global_mouse_position())
	print(global_position)
	position = get_global_mouse_position() #+ (global_position-get_global_mouse_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected :
		followMouse()
	pass


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		if event.pressed :
			selected = true
		else : 
			selected = false

	pass # Replace with function body.
