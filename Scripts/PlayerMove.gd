extends Node2D

var speed : int =  200
var pos : Vector2 = position
var grandeSalle : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position += Input.get_vector("left","right","up","down")*speed*delta
	if (grandeSalle == false) :
		#$CameraPersonnage.drag_horizontal_enabled = false
		#$CameraPersonnage.drag_vertical_enabled = false
		$CameraPersonnage.enabled = false
		$"../CameraFixe".enabled = true
	else :
		$CameraPersonnage.enabled = true
		$"../CameraFixe".enabled = false
	pass
