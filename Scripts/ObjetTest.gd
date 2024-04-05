extends Area2D

var selected = false
var collisioned = false
var test : Node2D
@export var spe_item : SpeItem
var peutgrab = true
var mouseOffset
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func followMouse() :
	#print(position)
	#print(get_global_mouse_position())
	#print(global_position)
	position = get_global_mouse_position() + mouseOffset #+ (global_position-get_global_mouse_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected :
		followMouse()
	if selected and collisioned :
		var SoiMeme = $Marker2D.global_position
		var Lautre = test.get_node("Marker2D").global_position
		if test.get_node("SpeItem").numSalle == self.get_node("SpeItem").numSalle :
			if abs(SoiMeme.x - Lautre.x) <= 10 :
				if abs(SoiMeme.y - Lautre.y) <= 10:
					var ObjetACreer = load("res://Nodes/Objets/"+ self.get_node("SpeItem").NomDeLaCle + ".tscn")
					var objetTombe = ObjetACreer.instantiate()
					objetTombe.position = self.global_position
					$"..".add_child(objetTombe)
					self.queue_free()
					test.queue_free()
	pass


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		if event.pressed :
			mouseOffset = position - get_global_mouse_position()
			selected = true
		else : 
			selected = false
	pass # Replace with function body.


func _on_area_entered(area):
	collisioned = true
	test = area
	pass # Replace with function body.


func _on_area_exited(area):
	collisioned = false
	pass # Replace with function body.
