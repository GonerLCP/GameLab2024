extends Node

var cleRecup= []
var currentRoom 
# Called when the node enters the scene tree for the first time.
func _ready():
	currentRoom = 5
	for i in 10 :
		cleRecup.append(0)
	pass # Replace with function body.i

func _process(delta):
	print(currentRoom)
	pass
