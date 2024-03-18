extends Sprite2D

var speed : int =  200
var pos : Vector2 = position

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position += Input.get_vector("left","right","up","down")*speed*delta
	pass
